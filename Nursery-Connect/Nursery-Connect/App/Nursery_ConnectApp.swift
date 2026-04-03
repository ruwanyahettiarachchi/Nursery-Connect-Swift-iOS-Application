//
//  Nursery_ConnectApp.swift
//  Nursery-Connect
//
//  Created by ruwanya hettiarachchi on 2026-03-25.
//

import SwiftUI
import SwiftData

// NurseryConnect processes special-category personal data (e.g. children's wellbeing). Under UK GDPR,
// such data falls within Article 9; handle it lawfully, proportionately, and in line with your policies.
// Persistence is on-device via SwiftData to prioritise privacy and local control of records.
// Diary and incident features align with EYFS expectations for recording daily experience and material events.

@main
struct Nursery_ConnectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Child.self,
            DiaryLog.self,
            Incident.self,
        ])
        // Local file-backed store only; data does not leave the device via this app's storage layer.
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
