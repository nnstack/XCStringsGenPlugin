import Foundation
import PackagePlugin

struct FileGenerator {
    static func generate(with catalogURL: URL, workDirectoryURL: URL) throws -> [Command] {
        let outputURL = workDirectoryURL.appendingPathComponent("Loc.swift")

        guard let data = try? Data(contentsOf: catalogURL) else {
            throw PluginError.catalogLoadingFailed
        }

        let catalog = try JSONDecoder().decode(StringCatalog.self, from: data)

        var content = """
        import Foundation

        enum Loc {
        """

        for (key, stringEntry) in catalog.strings.sorted(by: { $0.key < $1.key }) {
            guard let value = stringEntry.localizations[catalog.sourceLanguage]?.stringUnit.value else {
                continue
            }

            content += "\n"
            let camelCaseKey = key.camelCased()
            content += "  /// \(value)\n"
            if value.contains("%@") {
                content += """
                  static func \(camelCaseKey)(_ args: CVarArg...) -> String {
                    String(format: NSLocalizedString("\(key)", comment: ""), arguments: args)
                  }\n
                """
            } else {
                content += """
                  static let \(camelCaseKey): String = NSLocalizedString("\(key)", comment: "")\n
                """
            }
        }

        content += "}\n"

        try content.write(to: outputURL, atomically: true, encoding: .utf8)

        return [
            .buildCommand(
                displayName: "XCStringsGenPlugin",
                executable: URL(fileURLWithPath: "/usr/bin/env"),
                arguments: [
                    "echo", "File generated at: \(outputURL)"
                ],
                inputFiles: [catalogURL],
                outputFiles: [outputURL]
            )
        ]
    }
}
