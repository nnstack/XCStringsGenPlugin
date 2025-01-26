import Foundation
import PackagePlugin

extension FileList {
    var stringCatalogURLs: [URL] {
        filter { $0.url.pathExtension == "xcstrings" }.compactMap(\.url)
    }
}
