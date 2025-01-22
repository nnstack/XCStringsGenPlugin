#if canImport(XcodeProjectPlugin)
import Foundation
import PackagePlugin
import XcodeProjectPlugin

extension XCStringsGenPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        guard let stringCatalogURL = target.inputFiles.stringCatalogURL else {
            throw PluginError.catalogNotFound
        }

        return try FileGenerator.generate(
            with: stringCatalogURL,
            workDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
#endif
