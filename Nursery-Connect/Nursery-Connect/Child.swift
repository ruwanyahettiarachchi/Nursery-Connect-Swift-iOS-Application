import Foundation
import SwiftData

@Model
final class Child {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

