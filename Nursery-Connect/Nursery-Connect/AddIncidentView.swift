import SwiftUI
import SwiftData

struct AddIncidentView: View {
    let child: Child

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var descriptionText: String = ""
    @State private var bodyPart: String = "Other"

    var body: some View {
        Form {
            Section("Incident Details") {
                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )

                Picker("Body Part", selection: $bodyPart) {
                    Text("Head").tag("Head")
                    Text("Arm").tag("Arm")
                    Text("Leg").tag("Leg")
                    Text("Other").tag("Other")
                }

                ZStack(alignment: .topLeading) {
                    if descriptionText.isEmpty {
                        Text("Describe what happened...")
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 140)
                }
            }
        }
        .navigationTitle("New Incident")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Submit") {
                    let trimmedDescription = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)

                    let newIncident = Incident(
                        childName: child.name,
                        date: date,
                        descriptionText: trimmedDescription,
                        bodyPart: bodyPart
                    )
                    modelContext.insert(newIncident)
                    dismiss()
                }
                .disabled(descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    AddIncidentView(child: Child(name: "Ava", age: 3))
        .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}

