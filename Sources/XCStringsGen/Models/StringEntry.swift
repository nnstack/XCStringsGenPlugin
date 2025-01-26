import Foundation

struct StringEntry: Decodable {
    let extractionState: String
    let localizations: [String: StringLocalization]
}
