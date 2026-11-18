import Foundation

enum AssessmentError: Error {
    case emptyTitle
    case noItems
    case itemIndexOutOfBounds
    case cannotRemoveLastItem
}
