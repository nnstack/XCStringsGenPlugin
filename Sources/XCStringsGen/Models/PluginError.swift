import Foundation

enum PluginError: LocalizedError {
    case missingArguments
    case invalidCatalogPaths
    case invalidOutputPath
    case catalogLoadingFailed
    case fileWritingFailed(Error)

    var localizedDescription: String {
        switch self {
            case .missingArguments:
            return "Missing arguments. Usage: --catalogs {comma-separated URLs} --output {output path}"
        case .invalidCatalogPaths:
            return "One or more catalog paths are invalid."
        case .invalidOutputPath:
            return "The output path is invalid."
        case .catalogLoadingFailed:
            return "Failed to load the string catalog."
        case .fileWritingFailed(let error):
            return "Failed to write localization file: \(error)"
        }
    }
}
