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
        #expect(throws: AssessmentError.titleCannotBeEmpty) {
            try Assessment(title: "", items: [.sampleItem])
        }
        
        let assessment: Assessment = .sampleAssessment
        #expect(throws: AssessmentError.titleCannotBeEmpty) {
            try assessment.updateTitle("")
        }
    }
    
    @Test("Assessments cannot have zero multiple choice items.")
    func cannotHaveZeroItems() throws {
        #expect(throws: AssessmentError.itemsCannotBeEmpty) {
            try Assessment(title: "IREAD Practice", items: [])
        }
        
        let assessment = try Assessment(title: "IREAD Practice", items: [.sampleItem])
        #expect(throws: AssessmentError.itemsCannotBeEmpty) {
           try assessment.removeItem(at: 0)
        }
    }
    
    @Test("Add a multiple choice item to an existing assessment.")
    func addItemsToAssessment() throws {
        let assessment = try Assessment(title: "IREAD Practice", items: [.sampleItem])
        container.mainContext.insert(assessment)
        try container.mainContext.save()
        
        #expect (!assessment.items.isEmpty && assessment.items.count == 1)
        
        let item: MultipleChoiceItem = .sampleItem
        try assessment.addItem(item)
        
        #expect(!assessment.items.isEmpty && assessment.items.count == 2)
        #expect(assessment.items.contains(where: { $0.stem == item.stem }))
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
    
    @Test("Multiple choice items cannot have zero correct answers.")
    func cannotHaveZeroCorrectAnswers() throws {
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
    }

    @Test("Multiple choice items cannot have more than one correct answer.")
    func cannotHaveMultipleCorrectAnswers() throws {
        #expect(throws: MultipleChoiceItemError.tooManyCorrectAnswers) {
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
