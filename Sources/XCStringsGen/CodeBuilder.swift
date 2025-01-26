import Foundation

struct ContentBuilder {
    private(set) var content = ""
    private(set) var indentLevel: Int
    private let indentString: String = "    "

    init(indentLevel: Int = 0) {
        self.indentLevel = indentLevel
    }

    mutating func add(_ value: String) {
        content += String(repeating: indentString, count: indentLevel) + value + "\n"
    }

    mutating func add(verbatim value: String) {
        content += value
    }

    mutating func indent() {
        indentLevel += 1
    }

    mutating func outdent() {
        guard indentLevel > 0 else { return }
        indentLevel -= 1
    }
}
