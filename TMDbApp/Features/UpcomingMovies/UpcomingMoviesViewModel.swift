import Foundation
import Observation

@MainActor
@Observable
final class UpcomingMoviesViewModel {
    var movies: [Movie] = []
    var isLoading = false

    private var currentPage = 1
    private var canLoadMore = true
    private let service: any MovieService

    init(service: any MovieService) {
        self.service = service
    }

    func loadFirstPage() async {
        guard !isLoading else { return }
        currentPage = 1
        movies = []
        canLoadMore = true
        await load()
    }

    func loadNextPageIfNeeded(currentItem movie: Movie) async {
        guard let last = movies.last, last.id == movie.id,
              canLoadMore, !isLoading else { return }
        await load()
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await service.fetchUpcomingMovies(page: currentPage)
            movies += page.results
            currentPage += 1
            canLoadMore = page.hasNextPage
        } catch {
            // Silently handle errors; canLoadMore stays true to allow retry
        }
    }
}
