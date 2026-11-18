import Foundation
import SwiftData

/// A multiple choice item for an assessment.
struct MultipleChoiceItem: Codable {
    /// The stem (e.g., question or statement) that presents the problem.
    var stem: String
    /// The list of possible answers.
    var answers: [Answer]

    init(stem: String, answers: [Answer]) throws {
        guard !stem.isEmpty else { throw MultipleChoiceItemError.emptyStem }
        guard !answers.isEmpty else { throw MultipleChoiceItemError.noAnswers }
        
        // Validate there is one and only one correct answer.
        let correctAnswers: [Answer] = answers.filter(\MultipleChoiceItem.Answer.isCorrect)
        guard correctAnswers.count > 0 else { throw MultipleChoiceItemError.noCorrectAnswer}
        guard correctAnswers.count < 2 else { throw MultipleChoiceItemError.tooManyCorrectAnswers}
        
        self.stem = stem
        self.answers = answers
    }
    
    static let sampleItem = try! MultipleChoiceItem(
        stem: "Find the word that has the same vowel sound as 'left'.",
        answers: [
            MultipleChoiceItem.Answer("feel"),
            MultipleChoiceItem.Answer("belt", isCorrect: true),
            MultipleChoiceItem.Answer("hold"),
            MultipleChoiceItem.Answer("had"),
        ]
    )

    
    struct Answer: Codable {
        var text: String
        var isCorrect: Bool
        
        init(_ text: String, isCorrect: Bool = false) {
            self.text = text
            self.isCorrect = isCorrect
        }
    }
}
