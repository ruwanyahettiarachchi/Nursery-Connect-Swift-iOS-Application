import SwiftUI
import SwiftData

struct AddDiaryView: View {
    let child: Child
    private let diaryLogToEdit: DiaryLog?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var activity: String
    @State private var mood: String
    @State private var napStart: Date
    @State private var napEnd: Date
    @State private var nappyChanged: Bool
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false

    init(child: Child, diaryLogToEdit: DiaryLog? = nil) {
        self.child = child
        self.diaryLogToEdit = diaryLogToEdit
        if let log = diaryLogToEdit {
            _activity = State(initialValue: log.activity)
            _mood = State(initialValue: log.mood)
            _napStart = State(initialValue: log.napStart)
            _napEnd = State(initialValue: log.napEnd)
            _nappyChanged = State(initialValue: log.nappyChanged)
        } else {
            _activity = State(initialValue: "")
            _mood = State(initialValue: "Happy")
            _napStart = State(initialValue: Date())
            _napEnd = State(initialValue: Date())
            _nappyChanged = State(initialValue: false)
        }
    }

    private var isEditing: Bool { diaryLogToEdit != nil }

    var body: some View {
        Form {
            Section("Activity") {
                TextField("Activity", text: $activity)
            }

            Section("Mood & Nap") {
                Picker("Mood", selection: $mood) {
                    Text("Happy").tag("Happy")
                    Text("Sad").tag("Sad")
                    Text("Tired").tag("Tired")
                }

                DatePicker(
                    "Nap Start",
                    selection: $napStart,
                    displayedComponents: [.date, .hourAndMinute]
                )

                DatePicker(
                    "Nap End",
                    selection: $napEnd,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)

                Toggle("Nappy Changed", isOn: $nappyChanged)
            }
        }
        .scrollContentBackground(.hidden)
        .background(NurseryTheme.pageBackground.ignoresSafeArea(edges: [.horizontal, .bottom]))
        .navigationTitle(isEditing ? "Edit Diary Entry" : "New Diary Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveDiaryEntry()
                }
            }
        }
        .alert("Unable to Save Diary Entry", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func saveDiaryEntry() {
        let trimmedActivity = activity.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedActivity.isEmpty else {
            alertMessage = "Please enter the child's activity before saving."
            showAlert = true
            return
        }

        var insertedLog: DiaryLog?

        if let editing = diaryLogToEdit {
            editing.activity = trimmedActivity
            editing.mood = mood
            editing.napStart = napStart
            editing.napEnd = napEnd
            editing.nappyChanged = nappyChanged
            editing.childName = child.name
        } else {
            let newLog = DiaryLog(
                childName: child.name,
                activity: trimmedActivity,
                mood: mood,
                napStart: napStart,
                napEnd: napEnd,
                nappyChanged: nappyChanged,
                date: Date()
            )
            modelContext.insert(newLog)
            insertedLog = newLog
        }

        do {
            try modelContext.save()
            Haptics.diarySaved()
            dismiss()
        } catch {
            if let insertedLog {
                modelContext.delete(insertedLog)
            }
            alertMessage = "We couldn't save this diary entry. Please try again."
            showAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        AddDiaryView(child: Child(name: "Ava", age: 3))
    }
    .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}
