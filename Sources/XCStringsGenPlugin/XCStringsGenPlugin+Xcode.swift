#if canImport(XcodeProjectPlugin)
import Foundation
import PackagePlugin
import XcodeProjectPlugin

extension XCStringsGenPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return [
            try Command.xcStringsGen(
                forCatalogsAt: target.inputFiles.stringCatalogURLs,
                in: context.pluginWorkDirectoryURL,
                with: context.tool(named: "XCStringsGen")
            )
        ]
    }
}
#endif
