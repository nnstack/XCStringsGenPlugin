import XCTest
@testable import XCStringsGen

final class EntryGeneratorTests: XCTestCase {
    func testGenerateWithoutArguments() {
        let unit = StringUnit(state: "translated", value: "Hello World")
        let result = EntryGenerator.generate(for: "welcome_text", attributeName: "welcomeText", unit: unit, indentLevel: 0)

        let expected = """
        /// Hello World
        static let welcomeText: String = NSLocalizedString("welcome_text", comment: "")
        """
        
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func testGenerateWithArguments() {
        let unit = StringUnit(state: "translated", value: "Hello %@")
        let result = EntryGenerator.generate(for: "greeting_text", attributeName: "greetingText", unit: unit, indentLevel: 0)

        let expected = """
        /// Hello %@
        static func greetingText(_ arg1: String) -> String {
            String(format: NSLocalizedString("greeting_text", comment: ""), arg1)
        }
        """
        
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
