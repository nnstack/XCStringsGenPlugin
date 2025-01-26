import Foundation
import PackagePlugin

extension Command {
    static func xcStringsGen(
        forCatalogsAt catalogURLs: [URL],
        in workDirectoryURL: URL,
        with tool: PluginContext.Tool
    ) throws -> Command {
        let outputURL = workDirectoryURL.appending(path: "L10n.swift")

        return .buildCommand(
            displayName: "XCStringsGenPlugin",
            executable: tool.url,
            arguments: [
                "--catalogs",
                catalogURLs.map(\.path).joined(separator: ","),
                "--output",
                outputURL.path
            ],
            inputFiles: catalogURLs,
            outputFiles: [outputURL]
        )
    }
}
