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
        guard correctAnswers.count > 0 else { throw MultipleChoiceItemError.noCorrectAnswer }
        guard correctAnswers.count < 2 else { throw MultipleChoiceItemError.multipleCorrectAnswers }
        
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

    static let sampleItems: [MultipleChoiceItem] = [
        MultipleChoiceItem.sampleItem,
        try! MultipleChoiceItem(
            stem: "Find the word that has the same vowel sound as 'float'.",
            answers: [
                MultipleChoiceItem.Answer("broke", isCorrect: true),
                MultipleChoiceItem.Answer("flat"),
                MultipleChoiceItem.Answer("spoon"),
                MultipleChoiceItem.Answer("splat"),
            ]
        ),
        try! MultipleChoiceItem(
            stem: "Choose the word that means the same, or about the same, as 'delicious'.",
            answers: [
                MultipleChoiceItem.Answer("highly"),
                MultipleChoiceItem.Answer("tasty", isCorrect: true),
                MultipleChoiceItem.Answer("happy"),
                MultipleChoiceItem.Answer("slowly"),
            ]
        ),
        try! MultipleChoiceItem(
            stem: "Read these sentences. Choose the word that correctly completes both sentences.\nThe _____ is coming down the track.\nYou can _____ your dog to catch a ball.",
            answers: [
                MultipleChoiceItem.Answer("car"),
                MultipleChoiceItem.Answer("teach"),
                MultipleChoiceItem.Answer("train", isCorrect: true),
                MultipleChoiceItem.Answer("horse"),
            ]
        ),
    ]

    
    struct Answer: Codable {
        var text: String
        var isCorrect: Bool
        
        init(_ text: String, isCorrect: Bool = false) {
            self.text = text
            self.isCorrect = isCorrect
        }
    }
}
