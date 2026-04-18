import XCTest
import SwiftData
@testable import Nursery_Connect

final class NurseryConnectModelTests: XCTestCase {

    private func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([Child.self, DiaryLog.self, Incident.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    func testAddingDiaryEntrySavesAndFetches() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let newDiaryEntry = DiaryLog(
            childName: "Emma Brown",
            activity: "Outdoor play",
            mood: "Happy",
            napStart: Date().addingTimeInterval(-3600),
            napEnd: Date(),
            nappyChanged: true,
            date: Date()
        )

        context.insert(newDiaryEntry)
        try context.save()

        let descriptor = FetchDescriptor<DiaryLog>(
            predicate: #Predicate { $0.childName == "Emma Brown" },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let savedEntries = try context.fetch(descriptor)

        XCTAssertEqual(savedEntries.count, 1)
        XCTAssertEqual(savedEntries.first?.activity, "Outdoor play")
        XCTAssertEqual(savedEntries.first?.mood, "Happy")
        XCTAssertNotNil(savedEntries.first?.createdAt)
    }

    func testNapDurationMinutesComputesWholeMinutes() {
        let start = Date(timeIntervalSince1970: 0)
        let end = start.addingTimeInterval(90 * 60)
        let log = DiaryLog(
            childName: "Test",
            activity: "Nap",
            mood: "Tired",
            napStart: start,
            napEnd: end,
            nappyChanged: false,
            date: start
        )
        XCTAssertEqual(log.napDurationMinutes, 90)
    }

    func testIncidentCreationSavesAndFetches() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let newIncident = Incident(
            childName: "Oliver Smith",
            date: Date(),
            descriptionText: "Minor bump while running indoors.",
            bodyPart: "Head"
        )

        context.insert(newIncident)
        try context.save()

        let descriptor = FetchDescriptor<Incident>(
            predicate: #Predicate { $0.childName == "Oliver Smith" },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let savedIncidents = try context.fetch(descriptor)

        XCTAssertEqual(savedIncidents.count, 1)
        XCTAssertEqual(savedIncidents.first?.bodyPart, "Head")
        XCTAssertEqual(savedIncidents.first?.descriptionText, "Minor bump while running indoors.")
        XCTAssertNotNil(savedIncidents.first?.createdAt)
    }
}
