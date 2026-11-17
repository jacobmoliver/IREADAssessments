import Foundation
import SwiftData

/// A multiple choice item for an assessment.
@Model
class MultipleChoiceItem {
    /// The assessment that includes this item.
    @Relationship(inverse: \Assessment.items)
    var assessment: Assessment?
    /// The stem (e.g., question or statement) that presents the problem.
    var stem: String
    /// The list of possible answers.
    @Attribute(.codable)
    var answers: [Answer]

    init(on assessment: Assessment? = nil, stem: String, answers: [Answer]) throws {
        guard !stem.isEmpty else { throw MultipleChoiceItemError.emptyStem }
        guard !answers.isEmpty else { throw MultipleChoiceItemError.noAnswers }
        
        // Validate there is one and only one correct answer.
        let correctAnswers: [Answer] = answers.filter(\MultipleChoiceItem.Answer.isCorrect)
        guard correctAnswers.count > 0 else { throw MultipleChoiceItemError.noCorrectAnswer}
        guard correctAnswers.count < 2 else { throw MultipleChoiceItemError.tooManyCorrectAnswers}
        
        self.assessment = assessment
        self.stem = stem
        self.answers = answers
    }
    
    struct Answer: Codable {
        var text: String
        var isCorrect: Bool
        
        init(_ text: String, isCorrect: Bool = false) {
            self.text = text
            self.isCorrect = isCorrect
        }
    }
}
