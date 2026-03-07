import Foundation

public struct Genre: Decodable, Equatable, Sendable {
    public let id: Int
    public let name: String
}

public struct Movie: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let releaseDate: String
}

public struct MovieDetails: Decodable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let genres: [Genre]
    public let releaseDate: String
}

public struct MoviePage<T: Decodable & Equatable & Sendable>: Decodable, Equatable, Sendable {
    public let results: [T]
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int

    public var hasNextPage: Bool {
        page < totalPages
    }
}
