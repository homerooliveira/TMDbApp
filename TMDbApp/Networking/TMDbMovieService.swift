import Foundation

actor TMDbMovieService: MovieService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func fetchUpcomingMovies(page: Int) async throws -> Page<Movie> {
        let url = try TMDbEndpoint.upcomingMovies(page: page).url()
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(Page<Movie>.self, from: data)
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let url = try TMDbEndpoint.movieDetail(id: id).url()
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(MovieDetail.self, from: data)
    }

    func searchMovies(query: String) async throws -> Page<Movie> {
        let url = try TMDbEndpoint.searchMovies(query: query).url()
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(Page<Movie>.self, from: data)
    }
}
