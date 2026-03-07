import Testing
@testable import TMDbApp

@Suite("SearchMoviesViewModel")
@MainActor
struct SearchMoviesViewModelTests {

    @Test("empty search text clears movies without calling service")
    func emptySearchClearsMovies() async throws {
        let service = MockMovieService()
        let viewModel = SearchMoviesViewModel(service: service)

        viewModel.searchTextChanged("")
        try await Task.sleep(for: .milliseconds(400))

        #expect(viewModel.movies.isEmpty)
        #expect(service.searchCallCount == 0)
    }

    @Test("search calls service with correct query after debounce")
    func searchCallsServiceAfterDebounce() async throws {
        let service = MockMovieService()
        service.searchResult = .success(.mock(movies: [.mock()]))
        let viewModel = SearchMoviesViewModel(service: service)

        viewModel.searchTextChanged("Inception")
        try await Task.sleep(for: .milliseconds(400))

        #expect(service.searchCallCount == 1)
        #expect(service.lastSearchQuery == "Inception")
    }

    @Test("rapid typing cancels previous search tasks")
    func rapidTypingCancelsPreviousSearch() async throws {
        let service = MockMovieService()
        service.searchResult = .success(.mock())
        let viewModel = SearchMoviesViewModel(service: service)

        viewModel.searchTextChanged("I")
        viewModel.searchTextChanged("In")
        viewModel.searchTextChanged("Inc")
        try await Task.sleep(for: .milliseconds(400))

        #expect(service.searchCallCount == 1)
        #expect(service.lastSearchQuery == "Inc")
    }

    @Test("clearing search text resets movies")
    func clearingSearchTextResetsMovies() async throws {
        let service = MockMovieService()
        service.searchResult = .success(.mock(movies: [.mock()]))
        let viewModel = SearchMoviesViewModel(service: service)

        viewModel.searchTextChanged("test")
        try await Task.sleep(for: .milliseconds(400))

        viewModel.searchTextChanged("")
        #expect(viewModel.movies.isEmpty)
    }
}
