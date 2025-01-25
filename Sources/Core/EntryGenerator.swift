import Foundation

struct EntryGenerator {
    static func generate(for key: String, value: String) -> String {
        var parameters = [String]()
        var arguments = [String]()

        let types = TypeExtractor.extract(from: value)
        types.enumerated().forEach { (i, type) in
            parameters.append("_ arg\(i + 1): \(type)")
            arguments.append("arg\(i + 1)")
        }

        var content = "  /// \(value)\n"
        if types.count > 0 {
            let parameterString: String = parameters.joined(separator: ", ")
            let argumentString: String = arguments.joined(separator: ", ")
            content += """
              static func \(key)(\(parameterString)) -> String {
                String(format: NSLocalizedString("\(key)", comment: ""), \(argumentString))
              }\n
            """
        } else {
            content += """
              static let \(key): String = NSLocalizedString("\(key)", comment: "")\n
            """
        }
        return content
    }
}
