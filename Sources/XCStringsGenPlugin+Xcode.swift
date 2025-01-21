#if canImport(XcodeProjectPlugin)
import Foundation
import PackagePlugin
import XcodeProjectPlugin

extension XCStringsGenPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let stringCatalogURL = context.xcodeProject.directoryURL.appendingPathComponent("string_catalog.json")
        let outputURL = context.xcodeProject.directoryURL.appendingPathComponent("L10n.swift")

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
}
#endif
