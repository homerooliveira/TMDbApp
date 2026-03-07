import Testing
@testable import TMDbApp

@Suite("UpcomingMoviesViewModel")
@MainActor
struct UpcomingMoviesViewModelTests {

    @Test("loadFirstPage populates movies")
    func loadFirstPagePopulatesMovies() async {
        let service = MockMovieService()
        let movies = [Movie.mock(id: 1), Movie.mock(id: 2)]
        service.upcomingMoviesResult = .success(.mock(movies: movies, page: 1, totalPages: 3))
        let viewModel = UpcomingMoviesViewModel(service: service)

        await viewModel.loadFirstPage()

        #expect(viewModel.movies.count == 2)
        #expect(viewModel.movies[0].id == 1)
    }

    @Test("loadFirstPage resets movies on reload")
    func loadFirstPageResetsMovies() async {
        let service = MockMovieService()
        service.upcomingMoviesResult = .success(.mock(movies: [.mock(id: 1)], page: 1, totalPages: 1))
        let viewModel = UpcomingMoviesViewModel(service: service)
        await viewModel.loadFirstPage()

        service.upcomingMoviesResult = .success(.mock(movies: [.mock(id: 99)], page: 1, totalPages: 1))
        await viewModel.loadFirstPage()

        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies[0].id == 99)
    }

    @Test("loadNextPageIfNeeded appends movies")
    func loadNextPageAppends() async {
        let service = MockMovieService()
        service.upcomingMoviesResult = .success(.mock(movies: [.mock(id: 1)], page: 1, totalPages: 2))
        let viewModel = UpcomingMoviesViewModel(service: service)
        await viewModel.loadFirstPage()

        service.upcomingMoviesResult = .success(.mock(movies: [.mock(id: 2)], page: 2, totalPages: 2))
        await viewModel.loadNextPageIfNeeded(currentItem: viewModel.movies[0])

        #expect(viewModel.movies.count == 2)
        #expect(service.fetchUpcomingCallCount == 2)
    }

    @Test("loadNextPageIfNeeded does nothing for non-last item")
    func loadNextPageSkipsNonLastItem() async {
        let service = MockMovieService()
        let movies = [Movie.mock(id: 1), Movie.mock(id: 2)]
        service.upcomingMoviesResult = .success(.mock(movies: movies, page: 1, totalPages: 2))
        let viewModel = UpcomingMoviesViewModel(service: service)
        await viewModel.loadFirstPage()

        let countBefore = service.fetchUpcomingCallCount
        await viewModel.loadNextPageIfNeeded(currentItem: movies[0])

        #expect(service.fetchUpcomingCallCount == countBefore)
    }

    @Test("isLoading is false after successful fetch")
    func isLoadingFalseAfterFetch() async {
        let service = MockMovieService()
        service.upcomingMoviesResult = .success(.mock())
        let viewModel = UpcomingMoviesViewModel(service: service)

        await viewModel.loadFirstPage()

        #expect(viewModel.isLoading == false)
    }

    @Test("service error leaves movies empty and isLoading false")
    func serviceErrorHandledGracefully() async {
        let service = MockMovieService()
        service.upcomingMoviesResult = .failure(URLError(.notConnectedToInternet))
        let viewModel = UpcomingMoviesViewModel(service: service)

        await viewModel.loadFirstPage()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.isLoading == false)
    }
}
