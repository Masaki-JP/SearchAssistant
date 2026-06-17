import Foundation

extension URL {
    var replacingHTTPWithHTTPS: URL? {
        guard scheme?.lowercased() == "http" else { return nil }
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url
    }
}
