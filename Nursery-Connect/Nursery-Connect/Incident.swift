import Foundation
import SwiftData

@Model
final class Incident {
    var childName: String
    var date: Date
    var descriptionText: String
    var bodyPart: String

    init(
        childName: String,
        date: Date,
        descriptionText: String,
        bodyPart: String
    ) {
        self.childName = childName
        self.date = date
        self.descriptionText = descriptionText
        self.bodyPart = bodyPart
    }
}

