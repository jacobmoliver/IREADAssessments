import SwiftData
import Testing

@testable import IREADAssessments

@MainActor
@Suite
struct AssessmentTests {
    let container: ModelContainer
    
    init() throws {
        let schema = Schema([Assessment.self, MultipleChoiceItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    @Test("Assessments cannot have empty titles.")
    func cannotHaveEmptyTitle() throws {
        #expect(throws: AssessmentError.emptyTitle) {
            try Assessment(
                    title: "",
                    items: [
                    MultipleChoiceItem(
                        stem: "Find the word that has the same vowel sound as 'left'.",
                        answers: [
                            MultipleChoiceItem.Answer("feel"),
                            MultipleChoiceItem.Answer("belt", isCorrect: true),
                            MultipleChoiceItem.Answer("hold"),
                            MultipleChoiceItem.Answer("had"),
                        ]
                    )
                ]
            )
        }
    }
    
    @Test("Assessments cannot have zero multiple choice items.")
    func cannotHaveZeroItems() throws {
        #expect(throws: AssessmentError.zeroItems) {
            try Assessment(title: "IREAD Practice", items: [])
        }
    }
    
    @Test("Add a multiple choice item to an existing assessment.")
    func addItemsToAssessment() throws {
        let assessment = try! Assessment(
            title: "IREAD Practice Test",
            items: [
                MultipleChoiceItem(
                    stem: "Find the word that has the same vowel sound as 'left'.",
                    answers: [
                        MultipleChoiceItem.Answer("feel"),
                        MultipleChoiceItem.Answer("belt", isCorrect: true),
                        MultipleChoiceItem.Answer("hold"),
                        MultipleChoiceItem.Answer("had"),
                    ]
                )
            ]
        )
        container.mainContext.insert(assessment)
        try container.mainContext.save()
        
        #expect (!assessment.items.isEmpty && assessment.items.count == 1)
        
        let item = try MultipleChoiceItem(
            on: assessment,
            stem: "Find the word that means the same, or about the same, as 'delicious.'",
            answers: [
                MultipleChoiceItem.Answer("highly"),
                MultipleChoiceItem.Answer("tasty", isCorrect: true),
                MultipleChoiceItem.Answer("happy"),
                MultipleChoiceItem.Answer("slowly"),
            ]
        )
        container.mainContext.insert(item)
        try container.mainContext.save()

        #expect(!assessment.items.isEmpty && assessment.items.count == 2)
        #expect(assessment.items.contains(item))
        #expect(item.assessment === assessment)
    }

}

@MainActor
@Suite struct MultipleChoiceItemTests {
    let container: ModelContainer
    
    init() throws {
        let schema = Schema([Assessment.self, MultipleChoiceItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    @Test("Multiple choice items do not need assessments to initialize.")
    func doesNotNeedAssessment() throws {
        let item = try MultipleChoiceItem(
            stem: "Find the word that means the same, or about the same, as 'delicious.'",
            answers: [
                MultipleChoiceItem.Answer("highly"),
                MultipleChoiceItem.Answer("tasty", isCorrect: true),
                MultipleChoiceItem.Answer("happy"),
                MultipleChoiceItem.Answer("slowly"),
            ],
        )
        #expect(item.assessment == nil)
    }
    
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
