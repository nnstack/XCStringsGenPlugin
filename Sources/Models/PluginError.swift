import Foundation

enum PluginError: Error {
    case catalogNotFound
    case catalogLoadingFailed
    case sourceModuleNotFound
    case fileWritingFailed(Error)

    var localizedDescription: String {
        switch self {
        case .catalogNotFound:
            return "Unable to find any .xcstrings file."
        case .catalogLoadingFailed:
            return "Failed to load the string catalog."
        case .sourceModuleNotFound:
            return "Failed to load the string catalog."
        case .fileWritingFailed(let error):
            return "Failed to write localization file: \(error)"
        }
    }
}
