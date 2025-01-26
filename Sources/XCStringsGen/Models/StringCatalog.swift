import Foundation

struct StringCatalog: Decodable {
    let sourceLanguage: String
    let strings: [String: StringEntry]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceLanguage = try container.decode(String.self, forKey: .sourceLanguage)

        var stringsDict = [String: StringEntry]()
        let stringsContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .strings)

        // Attempt to decode each entry and ignore the ones that fail
        for key in stringsContainer.allKeys {
            if let entry = try? stringsContainer.decode(StringEntry.self, forKey: key) {
                stringsDict[key.stringValue] = entry
            }
        }

        self.strings = stringsDict
    }
}

private extension StringCatalog {
    private enum CodingKeys: String, CodingKey {
        case sourceLanguage
        case strings
    }

    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }
}

