import Foundation

enum ImageEndpoint {
    static let baseURLString = "https://image.tmdb.org/t/p"

    case poster(path: String)

    var url: URL? {
        switch self {
        case .poster(let path):
            return URL(string: "\(ImageEndpoint.baseURLString)/w154\(path)")
        }
    }
}
