import Foundation
import PackagePlugin

extension FileList {
    var stringCatalogURL: URL? {
        for resource in self where resource.url.pathExtension == "xcstrings" {
            return resource.url
        }
        return nil
    }
}
