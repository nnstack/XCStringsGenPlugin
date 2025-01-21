import Foundation
import PackagePlugin

@main
struct XCStringsGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        let stringCatalogURL = context.package.directoryURL.appendingPathComponent("string_catalog.json")
        let outputURL = context.package.directoryURL.appendingPathComponent("L10n.swift")

        try generateL10nFile(catalogURL: stringCatalogURL, outputURL: outputURL)

        return [
            .buildCommand(
                displayName: "Generate L10n.swift",
                executable: URL(fileURLWithPath: "/usr/bin/env"),
                arguments: ["echo", "Generating L10n.swift file..."],
                outputFiles: [outputURL]
            )
        ]
    }

    func generateL10nFile(catalogURL: URL, outputURL: URL) throws {
        guard let data = try? Data(contentsOf: catalogURL),
              let catalog = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            throw PluginError.catalogLoadingFailed
        }

        var content = """
        import Foundation

        enum L10n {
        """

        for (key, value) in catalog {
            let camelCaseKey = key.camelCased()
            if value.contains("%@") {
                content += """
                static func \(camelCaseKey)(_: CVarArg...) -> String {
                    return String(format: NSLocalizedString("\(key)", comment: ""), arguments: _)
                }
                """
            } else {
                content += """
                static let \(camelCaseKey): String = NSLocalizedString("\(key)", comment: "")
                """
            }
        }

        content += "\n}\n"

        try content.write(to: outputURL, atomically: true, encoding: .utf8)
    }
}

private extension String {
    func camelCased() -> String {
        let components = components(separatedBy: CharacterSet(charactersIn: "_-."))
        var camelCased = components.first?.lowercased() ?? ""
        components.dropFirst().forEach { camelCased += $0.capitalized }
        return camelCased
    }
}
