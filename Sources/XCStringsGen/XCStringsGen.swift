import Foundation
import ArgumentParser

@main
struct XCStringsGen: ParsableCommand {
    @Option(name: .long, help: "Comma-separated list of .xcstrings file paths")
    var catalogs: String

    @Option(name: .long, help: "Output path for generated Swift file")
    var output: String

    func run() throws {
        let catalogURLs = try parseCatalogPaths()
        let outputURL = try parseOutputPath()
        try generateFile(from: catalogURLs, to: outputURL)
        print("File generated at: \(outputURL.path)")
    }

    private func generateFile(from catalogURLs: [URL], to outputURL: URL) throws {
        var content = """
        import Foundation

        enum L10n {
        """

        for catalogURL in catalogURLs {
            let data = try Data(contentsOf: catalogURL)
            let catalog = try JSONDecoder().decode(StringCatalog.self, from: data)

            content += "\n"
            content += catalog.strings
                .sorted { $0.key < $1.key }
                .compactMap { key, entry in
                    guard let localization = entry.localizations[catalog.sourceLanguage] else { return nil }
                    return EntryGenerator.generate(for: key.camelCased(), value: localization.stringUnit.value)
                }
                .joined(separator: "\n")
        }

        content += "}\n"
        try content.write(to: outputURL, atomically: true, encoding: .utf8)
    }
}

private extension XCStringsGen {
    private func parseCatalogPaths() throws -> [URL] {
        let paths = catalogs.split(separator: ",").map(String.init)
        guard !paths.isEmpty else {
            throw PluginError.invalidCatalogPaths
        }

        return paths.map { path in
            let url = URL(fileURLWithPath: path).standardized
            guard FileManager.default.fileExists(atPath: url.path) else {
                fatalError("File not found at path: \(path)")
            }
            return url
        }
    }

    private func parseOutputPath() throws -> URL {
        let outputURL = URL(fileURLWithPath: output).standardized
        try FileManager.default.createDirectory(
            at: outputURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        return outputURL
    }
}
