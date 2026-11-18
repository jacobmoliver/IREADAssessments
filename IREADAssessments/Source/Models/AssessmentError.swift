import Foundation

enum AssessmentError: Error {
    case titleCannotBeEmpty
    case itemsCannotBeEmpty
    case itemIndexOutOfBounds
}
