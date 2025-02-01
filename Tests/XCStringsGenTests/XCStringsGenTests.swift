import XCTest
@testable import XCStringsGen

final class XCStringsGenTests: XCTestCase {
    func testGenerateFile() throws {
        let tempDir = NSTemporaryDirectory()
        let catalogPath = tempDir + "test.xcstrings"
        let outputFilePath = tempDir + "output.swift"

        let jsonString = """
        {
            "sourceLanguage": "en",
            "strings": {}
        }
        """
        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8), "Failed to convert JSON string to Data")
        FileManager.default.createFile(atPath: catalogPath, contents: jsonData)
        
        var generator = XCStringsGen()
        generator.catalogs = catalogPath
        generator.output = outputFilePath
        
        let catalogURLs = try generator.catalogs.parsedCatalogURLs()
        let outputURL = try generator.output.parsedOutputURL()

        try generator.generateFile(from: catalogURLs, to: outputURL)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: outputFilePath))
    }
}
