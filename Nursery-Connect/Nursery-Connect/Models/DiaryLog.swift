import Foundation
import SwiftData

// Daily diary: supports EYFS-aligned recording of activities, care, and routine (e.g. rest, wellbeing).
@Model
final class DiaryLog {
    var childName: String
    var activity: String
    var mood: String
    var napStart: Date
    var napEnd: Date
    var nappyChanged: Bool
    var date: Date
    /// Creation timestamp. SwiftData models use stored `var` properties; do not mutate after init.
    var createdAt: Date

    init(
        childName: String,
        activity: String,
        mood: String,
        napStart: Date,
        napEnd: Date,
        nappyChanged: Bool,
        date: Date,
        createdAt: Date = Date()
    ) {
        self.childName = childName
        self.activity = activity
        self.mood = mood
        self.napStart = napStart
        self.napEnd = napEnd
        self.nappyChanged = nappyChanged
        self.date = date
        self.createdAt = createdAt
    }

    /// Nap length in whole minutes (not persisted).
    var napDurationMinutes: Int {
        let seconds = napEnd.timeIntervalSince(napStart)
        let minutes = Int(seconds / 60.0)
        return max(0, minutes)
    }
}
