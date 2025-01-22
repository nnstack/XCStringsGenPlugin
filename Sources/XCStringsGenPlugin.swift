import Foundation
import PackagePlugin

@main
struct XCStringsGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        guard let sourceModule = target.sourceModule else {
            throw PluginError.sourceModuleNotFound
        }

        guard let stringCatalogURL = sourceModule.sourceFiles.stringCatalogURL else {
            throw PluginError.catalogNotFound
        }

        return try FileGenerator.generate(
            with: stringCatalogURL,
            workDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
