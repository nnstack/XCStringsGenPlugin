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
    }
}
