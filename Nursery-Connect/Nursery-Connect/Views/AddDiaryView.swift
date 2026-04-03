import SwiftUI
import SwiftData

struct AddDiaryView: View {
    let child: Child

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var activity: String = ""
    @State private var mood: String = "Happy"
    @State private var napStart: Date = Date()
    @State private var napEnd: Date = Date()
    @State private var nappyChanged: Bool = false

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
        .navigationTitle("New Diary Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let trimmedActivity = activity.trimmingCharacters(in: .whitespacesAndNewlines)

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
                    try? modelContext.save()
                    dismiss()
                }
                .disabled(activity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddDiaryView(child: Child(name: "Ava", age: 3))
    }
    .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}

