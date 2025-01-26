import Foundation

struct EntryGenerator {
    static func generate(for key: String, unit: StringUnit, indentLevel: Int) -> String {
        var contentBuilder = ContentBuilder(indentLevel: indentLevel)

        var parameters = [String]()
        var arguments = [String]()
        let types = TypeExtractor.extract(from: unit.value)
        types.enumerated().forEach { (i, type) in
            parameters.append("_ arg\(i + 1): \(type)")
            arguments.append("arg\(i + 1)")
        }

        let comment = unit.value.components(separatedBy: .whitespacesAndNewlines).joined(separator: " ")
        contentBuilder.add("/// \(comment)")
        if types.count > 0 {
            let parameterString: String = parameters.joined(separator: ", ")
            let argumentString: String = arguments.joined(separator: ", ")
            contentBuilder.add("static func \(key)(\(parameterString)) -> String {")
            contentBuilder.indent()
            contentBuilder.add("String(format: NSLocalizedString(\"\(key)\", comment: \"\"), \(argumentString))")
            contentBuilder.outdent()
            contentBuilder.add("}")
        } else {
            contentBuilder.add("static let \(key): String = NSLocalizedString(\"\(key)\", comment: \"\")")
        }
        return contentBuilder.content
    }
}
