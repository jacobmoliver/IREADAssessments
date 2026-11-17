import Foundation
import SwiftData

/// A multiple choice assessment.
@Model
class Assessment {
    /// The date and time when the assessment was created.
    var creationDate = Date()
    /// The title of the assessment.
    var title: String
    /// The list of multiple choice items on the assessment.
    var items: [MultipleChoiceItem]

    init(title: String, items: [MultipleChoiceItem]) throws {
        guard !title.isEmpty else { throw AssessmentError.emptyTitle }
        guard !items.isEmpty else { throw AssessmentError.zeroItems }
        
        self.title = title
        self.items = items
    }
}
