import Foundation

struct TypeExtractor {
    static func extract(from string: String) -> [String] {
        guard let regex = Self.regex else { return [] }

        let matches = regex.matches(
            in: string,
            range: NSRange(string.startIndex..., in: string)
        )

        return matches.compactMap {
            Range($0.range, in: string).flatMap {
                paramType(for: String(string[$0]))
            }
        }
    }

    private static var regex: NSRegularExpression? {
        let pattern = "%[0-9]*.?[0-9]*[hljztL]*[diouxXeEfFgGaAcCsSpn%@%]"
        return try? NSRegularExpression(pattern: pattern)
    }

    private static func paramType(for formatSpecifier: String) -> String? {
        switch formatSpecifier {
        case "%@":
            return String(describing: String.self)
        case "%i", "%d", "%lld":
            return String(describing: Int.self)
        case "%u", "%x", "%o":
            return String(describing: UInt.self)
        case "%a", "%e", "%f", "%g":
            return String(describing: Double.self)
        default:
            return nil
        }
    }
}

