import Foundation
import ArgumentParser

@main
struct XCStringsGen: ParsableCommand {
    @Option(name: .long, help: "Comma-separated list of .xcstrings file paths")
    var catalogs: String

    @Option(name: .long, help: "Output path for generated Swift file")
    var output: String

    func run() throws {
        let catalogURLs = try catalogs.parsedCatalogURLs()
        let outputURL = try output.parsedOutputURL()
        try generateFile(from: catalogURLs, to: outputURL)
        print("File generated at: \(outputURL.path)")
    }

    func generateFile(from catalogURLs: [URL], to outputURL: URL) throws {
        var contentBuilder = ContentBuilder()
        contentBuilder.add("import Foundation\n")
        contentBuilder.add("enum L10n {")

        let hasMoreThanOneCatalog = catalogURLs.count > 1
        for catalogURL in catalogURLs {
            let data = try Data(contentsOf: catalogURL)
            let catalog = try JSONDecoder().decode(StringCatalog.self, from: data)
            let fileName = catalogURL.deletingPathExtension().lastPathComponent

            if hasMoreThanOneCatalog {
                contentBuilder.indent()
                contentBuilder.add(verbatim: "\n")
                contentBuilder.add("enum \(fileName) {")
            }

            let entriesString = catalog.strings
                .compactMap { (key: String, entry: StringEntry) in
                    guard let attributeName = key.attributeName() else { return nil }
                    return (key, attributeName, entry)
                }
                .sorted { $0.1 < $1.1 }
                .compactMap { (key: String, attributeName: String, entry: StringEntry) -> String? in
                    guard let localization = entry.localizations[catalog.sourceLanguage] else { return nil }
                    return EntryGenerator.generate(
                        for: key,
                        attributeName: attributeName,
                        unit: localization.stringUnit,
                        indentLevel: contentBuilder.indentLevel + 1
                    )
                }
                .joined(separator: "\n")
            contentBuilder.add(verbatim: entriesString)

            if hasMoreThanOneCatalog {
                contentBuilder.add("}")
                contentBuilder.outdent()
            }
        }

        contentBuilder.add("}")

        try contentBuilder.content.write(to: outputURL, atomically: true, encoding: .utf8)
    }
}
