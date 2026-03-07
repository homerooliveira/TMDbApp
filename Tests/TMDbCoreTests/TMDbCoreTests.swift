import Foundation
import Testing
@testable import TMDbCore

struct TMDbCoreTests {
    @Test func upcomingRequestIncludesPageAndKey() throws {
        let request = try MovieEndpoint.upcoming(page: 3).request(configuration: AppConfiguration(apiKey: "secret"))
        #expect(request.url?.absoluteString == "https://api.themoviedb.org/3/movie/upcoming?page=3&api_key=secret")
    }

    @Test func searchRequestEncodesQuery() throws {
        let request = try MovieEndpoint.search(query: "Spider Man").request(configuration: AppConfiguration(apiKey: "secret"))
        #expect(request.url?.absoluteString.contains("query=Spider%20Man") == true)
    }

    @Test func posterURLHandlesEmptyPath() {
        #expect(MovieEndpoint.posterURL(path: nil) == nil)
        #expect(MovieEndpoint.posterURL(path: "") == nil)
        #expect(MovieEndpoint.posterURL(path: "/poster.jpg")?.absoluteString == "https://image.tmdb.org/t/p/w500/poster.jpg")
    }

    @Test func configurationLoadsFromEnvironment() throws {
        let configuration = try AppConfiguration.load(bundle: .main, environment: ["TMDB_API_KEY": "env-key"])
        #expect(configuration == AppConfiguration(apiKey: "env-key"))
    }

    @Test func configurationFallsBackToEmbeddedAPIKey() throws {
        let configuration = try AppConfiguration.load(bundle: .main, environment: [:])
        #expect(configuration == AppConfiguration(apiKey: AppConfiguration.embeddedAPIKey))
    }

    @Test @MainActor func upcomingModelStopsAtLastPage() async {
        let service = MockMovieService(
            upcomingPages: [
                .init(results: [.fixture(id: 1), .fixture(id: 2)], page: 1, totalResults: 2, totalPages: 1)
            ]
        )
        let model = UpcomingMoviesModel(service: service)

        await model.loadInitialPageIfNeeded()
        await model.loadNextPageIfNeeded(currentMovie: model.movies.last)

        #expect(model.movies.count == 2)
        #expect(await service.upcomingCalls == [1])
    }

    @Test @MainActor func searchModelClearsResultsForEmptyQuery() async {
        let service = MockMovieService(searchResult: .init(results: [.fixture(id: 99)], page: 1, totalResults: 1, totalPages: 1))
        let model = SearchMoviesModel(service: service)

        model.updateQuery("Batman")
        try? await Task.sleep(for: .milliseconds(350))
        #expect(model.movies.count == 1)

        model.updateQuery("")
        #expect(model.movies.isEmpty)
        #expect(model.errorMessage == nil)
    }

    @Test @MainActor func detailModelLoadsDetails() async {
        let service = MockMovieService(detail: .fixture())
        let model = MovieDetailModel(movie: .fixture(id: 7), service: service)

        await model.loadIfNeeded()

        #expect(model.details?.id == 7)
    }
}

private actor MockMovieService: MovieServicing {
    private(set) var upcomingCalls: [Int] = []
    private let upcomingPages: [MoviePage<Movie>]
    private let searchResult: MoviePage<Movie>
    private let detail: MovieDetails

    init(
        upcomingPages: [MoviePage<Movie>] = [.init(results: [.fixture(id: 1)], page: 1, totalResults: 1, totalPages: 2), .init(results: [.fixture(id: 2)], page: 2, totalResults: 2, totalPages: 2)],
        searchResult: MoviePage<Movie> = .init(results: [.fixture(id: 10)], page: 1, totalResults: 1, totalPages: 1),
        detail: MovieDetails = .fixture()
    ) {
        self.upcomingPages = upcomingPages
        self.searchResult = searchResult
        self.detail = detail
    }

    func upcomingMovies(page: Int) async throws -> MoviePage<Movie> {
        upcomingCalls.append(page)
        return upcomingPages[min(page - 1, upcomingPages.count - 1)]
    }

    func searchMovies(query: String) async throws -> MoviePage<Movie> {
        searchResult
    }

    func movieDetails(id: Int) async throws -> MovieDetails {
        detail
    }
}

private extension Movie {
    static func fixture(id: Int) -> Movie {
        Movie(id: id, title: "Movie \(id)", overview: "Overview \(id)", posterPath: "/poster\(id).jpg", releaseDate: "2024-01-01")
    }
}

private extension MovieDetails {
    static func fixture() -> MovieDetails {
        MovieDetails(id: 7, title: "Movie 7", overview: "Overview 7", posterPath: "/poster7.jpg", backdropPath: nil, genres: [Genre(id: 1, name: "Action")], releaseDate: "2024-01-01")
    }
}
