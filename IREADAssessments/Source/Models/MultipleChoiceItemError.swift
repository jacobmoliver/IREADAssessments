import Foundation

enum MultipleChoiceItemError: Error {
    case emptyStem
    case noAnswers
    case noCorrectAnswer
    case multipleCorrectAnswers
}
