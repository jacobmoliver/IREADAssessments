import SwiftData
import Testing

@testable import IREADAssessments

@MainActor
@Suite
struct AssessmentTests {

    let container: ModelContainer
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Assessment.self, configurations: config)
    }
    
    @Test("Assessments cannot have empty titles.")
    func cannotHaveEmptyTitle() throws {
        #expect(throws: AssessmentError.emptyTitle) {
            try Assessment(title: "", items: [.sampleItem])
        }
        
        let assessment: Assessment = .sampleAssessment
        #expect(throws: AssessmentError.emptyTitle) {
            try assessment.updateTitle("")
        }
    }
    
    @Test("Assessments cannot have zero multiple choice items.")
    func cannotHaveZeroItems() throws {
        #expect(throws: AssessmentError.noItems) {
            try Assessment(title: "IREAD Practice", items: [])
        }
        
        let assessment = try Assessment(title: "IREAD Practice", items: [.sampleItem])
        #expect(throws: AssessmentError.cannotRemoveLastItem) {
           try assessment.removeItem(at: 0)
        }
    }
    
    @Test("Add a multiple choice item to an existing assessment.")
    func addItemsToAssessment() throws {
        let assessment: Assessment = .sampleAssessment
        container.mainContext.insert(assessment)
        try container.mainContext.save()
        
        #expect (!assessment.items.isEmpty && assessment.items.count == 1)
        
        let item: MultipleChoiceItem = .sampleItems[1]
        try assessment.addItem(item)
        
        #expect(!assessment.items.isEmpty && assessment.items.count == 2)
        #expect(assessment.items.contains(where: { $0.stem == item.stem }))
    }

    @Test("Cannot remove the last multiple choice item on an assessment.")
    func cannotRemoveLastItem() throws {
        let assessment: Assessment = .sampleAssessment
        #expect(throws: AssessmentError.cannotRemoveLastItem) {
            try assessment.removeItem(at: 0)
        }
    }

    @Test("Add multiple choice items at specified indices.")
    func addItemsAtSpecifiedIndexes() throws {
        let sampleItems = MultipleChoiceItem.sampleItems
        let assessment = try Assessment(title: "IREAD Practice", items: [sampleItems[0]])

        try assessment.addItem(sampleItems[1], at: 0)
        try assessment.addItem(sampleItems[2], at: 1)
        try assessment.addItem(sampleItems[3], at: assessment.items.count)

        #expect(assessment.items.map(\.stem) == [
            sampleItems[1].stem,
            sampleItems[2].stem,
            sampleItems[0].stem,
            sampleItems[3].stem,
        ])
    }

    @Test("Cannot add a multiple choice item at an invalid index.")
    func cannotAddItemAtInvalidIndex() throws {
        let sampleItems = MultipleChoiceItem.sampleItems
        let assessment = try Assessment(title: "IREAD Practice", items: [sampleItems[0]])

        #expect(throws: AssessmentError.itemIndexOutOfBounds) {
            try assessment.addItem(sampleItems[1], at: assessment.items.count + 1)
        }
    }
}

@MainActor
@Suite struct MultipleChoiceItemTests {
    
    @Test("Multiple choice items cannot have empty stems.")
    func cannotHaveEmptyStem() throws {
        #expect(throws: MultipleChoiceItemError.emptyStem) {
            try MultipleChoiceItem(
                stem: "",
                answers: [
                    MultipleChoiceItem.Answer("highly"),
                    MultipleChoiceItem.Answer("tasty", isCorrect: true),
                    MultipleChoiceItem.Answer("happy"),
                    MultipleChoiceItem.Answer("slowly"),
                ]
            )
        }
    }
    
    @Test("Multiple choice items cannot have zero answers.")
    func cannotHaveZeroAnswers() throws {
        #expect(throws: MultipleChoiceItemError.noAnswers) {
            try MultipleChoiceItem(
                stem: "Find the word that means the same, or about the same, as 'delicious.'",
                answers: []
            )
        }
    }

    @Test("Multiple choice items must have exactly one correct answer.")
    func mustHaveExactlyOneCorrectAnswer() throws {
        #expect(throws: MultipleChoiceItemError.noCorrectAnswer) {
            try MultipleChoiceItem(
                stem: "Find the word that means the same, or about the same, as 'delicious.'",
                answers: [
                    MultipleChoiceItem.Answer("highly"),
                    MultipleChoiceItem.Answer("smelly"),
                    MultipleChoiceItem.Answer("happy"),
                    MultipleChoiceItem.Answer("slowly"),
                ]
            )
        }

        #expect(throws: MultipleChoiceItemError.multipleCorrectAnswers) {
            try MultipleChoiceItem(
                stem: "Find the word that means the same, or about the same, as 'delicious.'",
                answers: [
                    MultipleChoiceItem.Answer("highly"),
                    MultipleChoiceItem.Answer("tasty", isCorrect: true),
                    MultipleChoiceItem.Answer("appetizing", isCorrect: true),
                    MultipleChoiceItem.Answer("slowly"),
                ]
            )
        }
    }
}
