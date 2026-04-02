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

    init(
        childName: String,
        activity: String,
        mood: String,
        napStart: Date,
        napEnd: Date,
        nappyChanged: Bool,
        date: Date
    ) {
        self.childName = childName
        self.activity = activity
        self.mood = mood
        self.napStart = napStart
        self.napEnd = napEnd
        self.nappyChanged = nappyChanged
        self.date = date
    }
}

