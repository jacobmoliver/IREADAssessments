import Foundation
import SwiftData

/// A multiple choice assessment.
@Model
class Assessment {
    /// The date and time when the assessment was created.
    private(set) var creationDate = Date()
    /// The title of the assessment.
    private(set) var title: String
    /// The list of multiple choice items on the assessment.
    @Attribute(.codable)
    private(set) var items: [MultipleChoiceItem]

    init(title: String, items: [MultipleChoiceItem]) throws {
        guard !title.isEmpty else { throw AssessmentError.titleCannotBeEmpty }
        guard !items.isEmpty else { throw AssessmentError.itemsCannotBeEmpty }
        
        self.title = title
        self.items = items
    }
    
    func updateTitle(_ title: String) throws {
        guard !title.isEmpty else { throw AssessmentError.titleCannotBeEmpty }
        self.title = title
    }
    
    func addItem(_ item: MultipleChoiceItem) throws {
        guard !item.stem.isEmpty else { throw MultipleChoiceItemError.emptyStem }
        guard !item.answers.isEmpty else { throw MultipleChoiceItemError.noAnswers }
        items.append(item)
    }
    
    func removeItem(at index: Int) throws {
        guard index >= 0 && index < items.count else { throw AssessmentError.itemIndexOutOfBounds }
        guard items.count > 1 else { throw AssessmentError.itemsCannotBeEmpty }
        items.remove(at: index)
    }
    
    static var sampleAssessment = try! Assessment(title: "IREAD Practice", items: [.sampleItem])
}
