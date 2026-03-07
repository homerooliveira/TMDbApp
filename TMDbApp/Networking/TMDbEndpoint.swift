import Foundation

enum TMDbEndpoint {
    static let apiKey = "REMOVED_TMDB_API_KEY"
    static let baseURLString = "https://api.themoviedb.org/3"

    case upcomingMovies(page: Int)
    case movieDetail(id: Int)
    case searchMovies(query: String)

    func url() throws -> URL {
        var components = URLComponents(string: TMDbEndpoint.baseURLString)!
        switch self {
        case .upcomingMovies(let page):
            components.path += "/movie/upcoming"
            components.queryItems = [
                URLQueryItem(name: "api_key", value: TMDbEndpoint.apiKey),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .movieDetail(let id):
            components.path += "/movie/\(id)"
            components.queryItems = [
                URLQueryItem(name: "api_key", value: TMDbEndpoint.apiKey)
            ]
        case .searchMovies(let query):
            components.path += "/search/movie"
            components.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "api_key", value: TMDbEndpoint.apiKey)
            ]
        }
        guard let url = components.url else { throw URLError(.badURL) }
        return url
    }
}
