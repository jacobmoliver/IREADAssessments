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

    @Test("Add a multiple choice item to an assessment.")
    func addMultipleChoiceItemsToAssessment() {
        // Create and save an assessment without items.
        let assessment = Assessment(title: "IREAD Practice Test")
        container.mainContext.insert(assessment)
        try? container.mainContext.save()
        
        #expect(assessment.items.isEmpty)
        
        // Create and save a list of multiple choice items.
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
        try? container.mainContext.save()
        
        #expect(assessment.items.isEmpty == false && assessment.items.count == 1)
        #expect(assessment.items.contains(item))
        #expect(assessment.items.first === item)
        #expect(item.assessment === assessment)
    }
    
}
