import SwiftUI
import SwiftData

struct ChildDetailView: View {
    let child: Child

    @Query(sort: \DiaryLog.date, order: .reverse) private var diaryLogs: [DiaryLog]
    @Query(sort: \Incident.date, order: .reverse) private var incidents: [Incident]

    private var filteredDiaryLogs: [DiaryLog] {
        diaryLogs.filter { $0.childName == child.name }
    }

    private var filteredIncidents: [Incident] {
        incidents.filter { $0.childName == child.name }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(child.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("\(child.age) years old")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)

            List {
                Section("Daily Diary Logs") {
                    if filteredDiaryLogs.isEmpty {
                        ContentUnavailableView(
                            "No diary entries yet",
                            systemImage: "book.closed",
                            description: Text("Log activities and naps for this child.")
                        )
                    } else {
                        ForEach(filteredDiaryLogs) { log in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .top) {
                                    Image(systemName: "book.pages.fill")
                                        .foregroundStyle(.tint)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(log.activity)
                                            .font(.headline)
                                        Text("Mood: \(log.mood)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Text("Nap: \(log.napStart, style: .time) - \(log.napEnd, style: .time)")
                                    .foregroundStyle(.secondary)
                                Text(log.nappyChanged ? "Nappy changed" : "No nappy change")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(log.date, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    NavigationLink {
                        AddDiaryView(child: child)
                    } label: {
                        Label("Add Diary Entry", systemImage: "plus.circle")
                            .font(.callout)
                            .foregroundStyle(.tint)
                    }
                    .padding(.vertical, 4)
                }

                Section("Incident Reports") {
                    if filteredIncidents.isEmpty {
                        ContentUnavailableView(
                            "No incidents reported yet",
                            systemImage: "exclamationmark.triangle.fill",
                            description: Text("Record any incidents for this child.")
                        )
                    } else {
                        ForEach(filteredIncidents) { incident in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.orange)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(incident.bodyPart)
                                            .font(.headline)
                                        Text(incident.descriptionText)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(3)
                                    }
                                }
                                Text(incident.date, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    NavigationLink {
                        AddIncidentView(child: child)
                    } label: {
                        Label("Add Incident", systemImage: "plus.circle")
                            .font(.callout)
                            .foregroundStyle(.tint)
                    }
                    .padding(.vertical, 4)
                }
            }

            .listStyle(.insetGrouped)
        }
        .navigationTitle(child.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChildDetailView(child: Child(name: "Ava", age: 3))
        .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}

