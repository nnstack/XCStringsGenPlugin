import XCTest
@testable import XCStringsGen

final class ContentBuilderTests: XCTestCase {
    func testInitialState() {
        let builder = ContentBuilder()
        XCTAssertEqual(builder.content, "")
        XCTAssertEqual(builder.indentLevel, 0)
    }
    
    func testAdd() {
        var builder = ContentBuilder()
        builder.add("Content")
        XCTAssertEqual(builder.content, "Content\n")
    }
    
    func testAddWithIndent() {
        var builder = ContentBuilder(indentLevel: 1)
        builder.add("Indented")
        XCTAssertEqual(builder.content, "    Indented\n")
    }
    
    func testAddVerbatim() {
        var builder = ContentBuilder()
        builder.add(verbatim: "Content")
        XCTAssertEqual(builder.content, "Content")
    }
    
    func testIndent() {
        var builder = ContentBuilder()
        builder.indent()
        XCTAssertEqual(builder.indentLevel, 1)
    }
    
    func testOutdent() {
        var builder = ContentBuilder(indentLevel: 2)
        builder.outdent()
        XCTAssertEqual(builder.indentLevel, 1)
    }
    
    func testOutdentDoesNotGoNegative() {
        var builder = ContentBuilder()
        builder.outdent()
        XCTAssertEqual(builder.indentLevel, 0)
    }
}
