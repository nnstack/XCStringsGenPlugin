import Foundation

enum PluginError: Error {
    case catalogLoadingFailed
    case fileWritingFailed(Error)

    var localizedDescription: String {
        switch self {
        case .catalogLoadingFailed:
            return "Failed to load the string catalog."
        case .fileWritingFailed(let error):
            return "Failed to write L10n.swift: \(error)"
        }
    }
}
