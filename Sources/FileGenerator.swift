import Foundation
import PackagePlugin

struct FileGenerator {
    static func generate(with catalogURL: URL, workDirectoryURL: URL) throws -> [Command] {
        let outputURL = workDirectoryURL.appendingPathComponent("L10n.swift")

        return [
            .buildCommand(
                displayName: "XCStringsGenPlugin: Generate L10n.swift",
                executable: URL(fileURLWithPath: "/usr/bin/env"),
                arguments: [
                    "echo", "File generated at: \(outputURL)"
                ],
                outputFiles: [outputURL]
            )
        ]
    }
}
