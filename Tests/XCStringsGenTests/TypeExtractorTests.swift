import XCTest
@testable import XCStringsGen

final class TypeExtractorTests: XCTestCase {
    func testExtractStringType() {
        let result = TypeExtractor.extract(from: "Hello %@")
        XCTAssertEqual(result, [String(describing: String.self)])
    }
    
    func testExtractIntType() {
        let result = TypeExtractor.extract(from: "Number: %d")
        XCTAssertEqual(result, [String(describing: Int.self)])
    }
    
    func testExtractMultipleTypes() {
        let result = TypeExtractor.extract(from: "User %@ has %d points and %.2f balance")
        XCTAssertEqual(result, [
            String(describing: String.self),
            String(describing: Int.self),
            String(describing: Double.self)
        ])
    }
    
    func testExtractUnsignedIntType() {
        let result = TypeExtractor.extract(from: "Hex: %x")
        XCTAssertEqual(result, [String(describing: UInt.self)])
    }
    
    func testExtractDoubleType() {
        let result = TypeExtractor.extract(from: "Float: %f")
        XCTAssertEqual(result, [String(describing: Double.self)])
    }
    
    func testExtractUnknownSpecifier() {
        let result = TypeExtractor.extract(from: "Unknown: %q")
        XCTAssertEqual(result, [])
    }
    
    func testExtractWithNoSpecifiers() {
        let result = TypeExtractor.extract(from: "Just a normal string")
        XCTAssertEqual(result, [])
    }
}
