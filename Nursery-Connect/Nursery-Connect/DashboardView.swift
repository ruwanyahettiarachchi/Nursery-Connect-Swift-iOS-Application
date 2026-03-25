import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Child.name) private var children: [Child]

    var body: some View {
        NavigationStack {
            List {
                if children.isEmpty {
                    ContentUnavailableView(
                        "No children yet",
                        systemImage: "person.3.fill",
                        description: Text("Add a child to start logging daily activities and incidents.")
                    )
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(children) { child in
                        NavigationLink {
                            ChildDetailView(child: child)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(.tint)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(child.name)
                                        .font(.headline)
                                    Text("\(child.age) years old")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Little Stars Nursery")
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}

