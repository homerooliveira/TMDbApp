import Foundation

public protocol MovieServicing: Sendable {
    func upcomingMovies(page: Int) async throws -> MoviePage<Movie>
    func searchMovies(query: String) async throws -> MoviePage<Movie>
    func movieDetails(id: Int) async throws -> MovieDetails
}

public protocol HTTPSession: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {}

public enum MovieServiceError: LocalizedError, Equatable, Sendable {
    case invalidPage
    case invalidResponse
    case requestFailed(statusCode: Int)

    public var errorDescription: String? {
        switch self {
        case .invalidPage:
            return "The page must be greater than zero."
        case .invalidResponse:
            return "The server response was invalid."
        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."
        }
    }
}

public enum MovieEndpoint: Sendable, Equatable {
    case upcoming(page: Int)
    case search(query: String)
    case detail(id: Int)

    private static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!

    public func request(configuration: AppConfiguration) throws -> URLRequest {
        switch self {
        case .upcoming(let page):
            guard page > 0 else { throw MovieServiceError.invalidPage }
            return try buildRequest(path: "/movie/upcoming", queryItems: [
                URLQueryItem(name: "page", value: String(page))
            ], configuration: configuration)
        case .search(let query):
            return try buildRequest(path: "/search/movie", queryItems: [
                URLQueryItem(name: "query", value: query)
            ], configuration: configuration)
        case .detail(let id):
            return try buildRequest(path: "/movie/\(id)", queryItems: [], configuration: configuration)
        }
    }

    public static func posterURL(path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return imageBaseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }

    private func buildRequest(
        path: String,
        queryItems: [URLQueryItem],
        configuration: AppConfiguration
    ) throws -> URLRequest {
        var components = URLComponents(url: MovieEndpoint.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems + [
            URLQueryItem(name: "api_key", value: configuration.apiKey)
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        return URLRequest(url: url)
    }
}

public struct LiveMovieService: MovieServicing, Sendable {
    private let configuration: AppConfiguration
    private let session: any HTTPSession
    private let decoder: JSONDecoder

    public init(
        configuration: AppConfiguration,
        session: any HTTPSession = URLSession.shared,
        decoder: JSONDecoder = LiveMovieService.makeDefaultDecoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
    }

    public func upcomingMovies(page: Int) async throws -> MoviePage<Movie> {
        try await perform(.upcoming(page: page), as: MoviePage<Movie>.self)
    }

    public func searchMovies(query: String) async throws -> MoviePage<Movie> {
        try await perform(.search(query: query), as: MoviePage<Movie>.self)
    }

    public func movieDetails(id: Int) async throws -> MovieDetails {
        try await perform(.detail(id: id), as: MovieDetails.self)
    }

    private func perform<T: Decodable & Sendable>(_ endpoint: MovieEndpoint, as type: T.Type) async throws -> T {
        let request = try endpoint.request(configuration: configuration)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieServiceError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw MovieServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }

        return try decoder.decode(type, from: data)
    }

    public static func makeDefaultDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
