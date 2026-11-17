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
                        answerChoices: [
                            MultipleChoiceItem.AnswerChoice("feel"),
                            MultipleChoiceItem.AnswerChoice("belt", isCorrect: true),
                            MultipleChoiceItem.AnswerChoice("hold"),
                            MultipleChoiceItem.AnswerChoice("had"),
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
                MultipleChoiceItem(stem: "Find the word that has the same vowel sound as 'left'.", answerChoices: [
                    MultipleChoiceItem.AnswerChoice("feel"),
                    MultipleChoiceItem.AnswerChoice("belt", isCorrect: true),
                    MultipleChoiceItem.AnswerChoice("hold"),
                    MultipleChoiceItem.AnswerChoice("had"),
                ])
            ]
        )
        container.mainContext.insert(assessment)
        try container.mainContext.save()
        
        let item = MultipleChoiceItem(
            on: assessment,
            stem: "Find the word that means the same, or about the same, as 'delicious.'",
            answerChoices: [
                MultipleChoiceItem.AnswerChoice("highly"),
                MultipleChoiceItem.AnswerChoice("tasty", isCorrect: true),
                MultipleChoiceItem.AnswerChoice("happy"),
                MultipleChoiceItem.AnswerChoice("slowly"),
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
    func createMultipleChoiceItem() {
        let item = MultipleChoiceItem(
            stem: "Find the word that means the same, or about the same, as 'delicious.'",
            answerChoices: [
                MultipleChoiceItem.AnswerChoice("highly"),
                MultipleChoiceItem.AnswerChoice("tasty", isCorrect: true),
                MultipleChoiceItem.AnswerChoice("happy"),
                MultipleChoiceItem.AnswerChoice("slowly"),
            ],
        )
        #expect(item.assessment == nil)
    }
}
