import Foundation
import SwiftData

/// A multiple choice assessment.
@Model
class Assessment {
    /// The date and time when the assessment was created.
    var creationDate = Date()
    /// The title of the assessment.
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
