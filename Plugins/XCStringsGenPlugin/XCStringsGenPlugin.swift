import Foundation
import PackagePlugin

@main
struct XCStringsGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        guard let sourceModule = target.sourceModule else {
            Diagnostics.warning("XCStringsGenPlugin: Source module not found for target '\(target.name)'")
            return []
        }

        return [
            try .xcStringsGen(
                forCatalogsAt: sourceModule.sourceFiles.stringCatalogURLs,
                in: context.pluginWorkDirectoryURL,
                with: context.tool(named: "XCStringsGen")
            )
        ]
    }
}

