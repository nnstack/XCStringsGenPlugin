import Foundation

extension String {
    func camelCased() -> String {
        let components = components(separatedBy: CharacterSet(charactersIn: "_-."))
        var camelCased = components.first ?? ""
        camelCased = camelCased.prefix(1).lowercased() + camelCased.suffix(camelCased.count - 1)
        components.dropFirst().forEach { camelCased += $0.capitalized }
        return camelCased
    }
}
