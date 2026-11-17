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
    
    @Test("Throw an error when creating an assesssment with an empty title.")
    func createAssessmentWithEmptyTitle() throws {
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
    
    @Test("Throw an error when creating an assessment without items.")
    func createEmptyAssessment() throws {
        #expect(throws: AssessmentError.zeroItems) {
            try Assessment(title: "IREAD Practice", items: [])
        }
    }
    
    @Test("Add a multiple choice item to an assessment.")
    func addMultipleChoiceItemsToAssessment() throws {
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
    
    @Test("Create a multiple choice item without an assessment.")
    func createMultipleChoiceItem() throws {
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
    
    @Test("Create a multiple choice item with an empty stem.")
    func createMultipleChoiceItemWithEmptyStem() throws {
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
    
    @Test("Cannot have zero correct answers per multiple choice item.")
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

    @Test("Cannot have multiple correct answers per multiple choice item.")
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
