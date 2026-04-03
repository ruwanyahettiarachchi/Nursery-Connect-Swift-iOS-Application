import SwiftUI
import SwiftData

struct ChildDetailView: View {
    let child: Child

    @Query private var diaryLogs: [DiaryLog]
    @Query private var incidents: [Incident]

    private enum ActiveSheet: String, Identifiable {
        case addDiary
        case addIncident
        var id: String { rawValue }
    }

    @State private var activeSheet: ActiveSheet?

    init(child: Child) {
        self.child = child
        let childName = child.name
        _diaryLogs = Query(
            filter: #Predicate<DiaryLog> { log in
                log.childName == childName
            },
            sort: \DiaryLog.date,
            order: .reverse
        )
        _incidents = Query(
            filter: #Predicate<Incident> { incident in
                incident.childName == childName
            },
            sort: \Incident.date,
            order: .reverse
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                diarySectionCard

                incidentSectionCard
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .padding(.bottom, 8)
        }
        // Do not extend background under the nav bar — full-screen ignoresSafeArea can block the back button.
        .background(NurseryTheme.pageBackground.ignoresSafeArea(edges: [.horizontal, .bottom]))
        .navigationTitle(child.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(item: $activeSheet) { sheet in
            NavigationStack {
                Group {
                    switch sheet {
                    case .addDiary:
                        AddDiaryView(child: child)
                    case .addIncident:
                        AddIncidentView(child: child)
                    }
                }
                .tint(NurseryTheme.accent)
            }
            .presentationDragIndicator(.visible)
        }
    }

    private var headerCard: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [NurseryTheme.accent.opacity(0.35), NurseryTheme.mint.opacity(0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(NurseryTheme.accent)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(child.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Label {
                    Text("\(child.age) years old")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "figure.child")
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .nurseryCard()
    }

    private var diarySectionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(
                title: "Daily Diary Logs",
                systemImage: "book.pages.fill",
                tint: NurseryTheme.diaryTint
            )

            if diaryLogs.isEmpty {
                emptyPlaceholder(
                    title: "No diary entries yet",
                    subtitle: "Tap below to record activities, mood, and rest.",
                    systemImage: "book.closed.fill"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(diaryLogs) { log in
                        diaryEntryRow(log)
                    }
                }
            }

            Button {
                activeSheet = .addDiary
            } label: {
                Label("Add Diary Entry", systemImage: "plus.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [NurseryTheme.diaryTint.opacity(0.35), NurseryTheme.mint.opacity(0.4)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .nurseryCard()
    }

    private var incidentSectionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(
                title: "Incident Reports",
                systemImage: "exclamationmark.shield.fill",
                tint: NurseryTheme.incidentTint
            )

            if incidents.isEmpty {
                emptyPlaceholder(
                    title: "No incidents reported",
                    subtitle: "Record any bumps or concerns when they happen.",
                    systemImage: "checkmark.shield.fill"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(incidents) { incident in
                        incidentRow(incident)
                    }
                }
            }

            Button {
                activeSheet = .addIncident
            } label: {
                Label("Add Incident", systemImage: "plus.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [NurseryTheme.incidentTint.opacity(0.85), NurseryTheme.sunshine.opacity(0.75)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .nurseryCard()
    }

    private func sectionHeader(title: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(tint)
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
        }
    }

    private func emptyPlaceholder(title: String, subtitle: String, systemImage: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(NurseryTheme.accent.opacity(0.45))
            Text(title)
                .font(.subheadline.weight(.semibold))
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private func diaryEntryRow(_ log: DiaryLog) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: moodSymbol(for: log.mood))
                    .font(.title3)
                    .foregroundStyle(NurseryTheme.diaryTint)
                    .frame(width: 28, alignment: .center)

                VStack(alignment: .leading, spacing: 6) {
                    Text(log.activity)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)

                    HStack(spacing: 8) {
                        Label(log.mood, systemImage: "heart.fill")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(NurseryTheme.accent)
                        Text("•")
                            .foregroundStyle(.tertiary)
                        Label {
                            Text(log.date, style: .date)
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
            }

            Divider()
                .opacity(0.35)

            HStack(spacing: 12) {
                Label {
                    Text("\(log.napStart, style: .time) – \(log.napEnd, style: .time)")
                } icon: {
                    Image(systemName: "moon.zzz.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Spacer(minLength: 0)

                Label(
                    log.nappyChanged ? "Nappy changed" : "No change",
                    systemImage: log.nappyChanged ? "checkmark.circle.fill" : "circle"
                )
                .font(.caption)
                .foregroundStyle(log.nappyChanged ? NurseryTheme.mint : .secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.65))
        )
    }

    private func incidentRow(_ incident: Incident) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: "bandage.fill")
                    .font(.title3)
                    .foregroundStyle(NurseryTheme.incidentTint)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(incident.bodyPart)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(NurseryTheme.incidentTint.opacity(0.22))
                            )
                            .foregroundStyle(.primary)

                        Spacer(minLength: 0)

                        Label {
                            HStack(spacing: 4) {
                                Text(incident.date, style: .date)
                                Text("·")
                                    .foregroundStyle(.tertiary)
                                Text(incident.date, style: .time)
                            }
                        } icon: {
                            Image(systemName: "clock.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    Text(incident.descriptionText)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.65))
        )
    }

    private func moodSymbol(for mood: String) -> String {
        switch mood {
        case "Happy": return "face.smiling.fill"
        case "Sad": return "cloud.rain.fill"
        case "Tired": return "bed.double.fill"
        default: return "leaf.fill"
        }
    }
}

#Preview {
    NavigationStack {
        ChildDetailView(child: Child(name: "Ava", age: 3))
    }
    .modelContainer(for: [Child.self, DiaryLog.self, Incident.self], inMemory: true)
}
