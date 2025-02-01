import Foundation
import SwiftParser

extension String {
    private var separators: String { "_-." }

    private func escapedAttributeNameIfReserved() -> String {
        isValidSwiftIdentifier(for: .variableName) ? self : "`\(self)`"
    }

    private func camelCased() -> String {
        let components = components(separatedBy: CharacterSet(charactersIn: separators))
        var camelCased = components.first ?? ""
        camelCased = camelCased.prefix(1).lowercased() + camelCased.suffix(camelCased.count - 1)
        components.dropFirst().forEach { camelCased += $0.capitalized }
        return camelCased
    }

    func attributeName() -> String? {
        let regexSeparators = separators.replacingOccurrences(of: "-", with: "\\-")
        var sanitized = replacingOccurrences(
            of: "[^a-zA-Z0-9\(regexSeparators)]",
            with: "",
            options: .regularExpression
        )

        if sanitized.count > 0, sanitized.first?.isNumber ?? false {
            sanitized = String(sanitized.dropFirst())
        }

        return sanitized.isEmpty ? nil : sanitized.camelCased().escapedAttributeNameIfReserved()
    }

    func parsedCatalogURLs() throws -> [URL] {
        let paths = split(separator: ",").map(String.init)
        guard !paths.isEmpty else {
            throw PluginError.invalidCatalogPaths
        }

        return paths.map { path in
            let url = URL(fileURLWithPath: path).standardized
            guard FileManager.default.fileExists(atPath: url.path) else {
                fatalError("File not found at path: \(path)")
            }
            return url
        }
    }

    func parsedOutputURL() throws -> URL {
        let outputURL = URL(fileURLWithPath: self).standardized
        try FileManager.default.createDirectory(
            at: outputURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        return outputURL
    }
}
