import Foundation
@testable import TMDbApp

final class MockMovieService: MovieService, @unchecked Sendable {
    var upcomingMoviesResult: Result<Page<Movie>, Error> = .success(
        Page(results: [], page: 1, totalResults: 0, totalPages: 1)
    )
    var movieDetailResult: Result<MovieDetail, Error> = .success(
        MovieDetail(id: 1, title: "Mock Movie", posterPath: nil, backdropPath: nil, genres: [], releaseDate: "2024-01-01")
    )
    var searchResult: Result<Page<Movie>, Error> = .success(
        Page(results: [], page: 1, totalResults: 0, totalPages: 1)
    )

    private(set) var fetchUpcomingCallCount = 0
    private(set) var fetchDetailCallCount = 0
    private(set) var searchCallCount = 0
    private(set) var lastSearchQuery: String?
    private(set) var lastDetailId: Int?

    func fetchUpcomingMovies(page: Int) async throws -> Page<Movie> {
        fetchUpcomingCallCount += 1
        return try upcomingMoviesResult.get()
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        fetchDetailCallCount += 1
        lastDetailId = id
        return try movieDetailResult.get()
    }

    func searchMovies(query: String) async throws -> Page<Movie> {
        searchCallCount += 1
        lastSearchQuery = query
        return try searchResult.get()
    }
}

extension Movie {
    static func mock(id: Int = 1, title: String = "Mock Movie") -> Movie {
        Movie(id: id, title: title, overview: "Mock overview", posterPath: nil, releaseDate: "2024-01-01")
    }
}

extension Page where T == Movie {
    static func mock(movies: [Movie] = [], page: Int = 1, totalPages: Int = 1) -> Page<Movie> {
        Page(results: movies, page: page, totalResults: movies.count, totalPages: totalPages)
    }
}
