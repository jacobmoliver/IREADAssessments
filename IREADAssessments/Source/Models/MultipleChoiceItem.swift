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
    var answerChoices: [AnswerChoice]

    init(on assessment: Assessment? = nil, stem: String, answerChoices: [AnswerChoice] = []) {
        self.assessment = assessment
        self.stem = stem
        self.answerChoices = answerChoices
    }
    
    struct AnswerChoice: Codable {
        var text: String
        var isCorrect: Bool
        
        init(_ text: String, isCorrect: Bool = false) {
            self.text = text
            self.isCorrect = isCorrect
        }
    }
}
