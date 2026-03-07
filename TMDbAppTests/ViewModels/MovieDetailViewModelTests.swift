import Testing
@testable import TMDbApp

@Suite("MovieDetailViewModel")
@MainActor
struct MovieDetailViewModelTests {

    @Test("load populates detail")
    func loadPopulatesDetail() async {
        let service = MockMovieService()
        let viewModel = MovieDetailViewModel(movie: .mock(), service: service)

        await viewModel.load()

        #expect(viewModel.detail != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("load calls service with correct movie ID")
    func loadCallsServiceWithCorrectID() async {
        let service = MockMovieService()
        let viewModel = MovieDetailViewModel(movie: .mock(id: 42), service: service)

        await viewModel.load()

        #expect(service.lastDetailId == 42)
    }

    @Test("load failure leaves detail nil")
    func loadFailureLeavesDetailNil() async {
        let service = MockMovieService()
        service.movieDetailResult = .failure(URLError(.badServerResponse))
        let viewModel = MovieDetailViewModel(movie: .mock(), service: service)

        await viewModel.load()

        #expect(viewModel.detail == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("isLoading is false after successful load")
    func isLoadingFalseAfterLoad() async {
        let service = MockMovieService()
        let viewModel = MovieDetailViewModel(movie: .mock(), service: service)

        await viewModel.load()

        #expect(viewModel.isLoading == false)
    }
}
