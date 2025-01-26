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
            environment: [
                // Disables LLVM profile collection for this tool to prevent sandbox write errors
                "LLVM_PROFILE_FILE": "/dev/null"
            ],
            inputFiles: catalogURLs,
            outputFiles: [outputURL]
        )
    }
}
