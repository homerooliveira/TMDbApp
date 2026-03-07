import Foundation
import Observation

@MainActor
@Observable
public final class UpcomingMoviesModel {
    public private(set) var movies: [Movie] = []
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?

    @ObservationIgnored private let service: any MovieServicing
    @ObservationIgnored private var currentPage = 0
    @ObservationIgnored private var hasNextPage = true

    public init(service: any MovieServicing) {
        self.service = service
    }

    public func loadInitialPageIfNeeded() async {
        guard movies.isEmpty else { return }
        await refresh()
    }

    public func refresh() async {
        currentPage = 0
        hasNextPage = true
        movies = []
        await loadPage(1, replacing: true)
    }

    public func loadNextPageIfNeeded(currentMovie: Movie?) async {
        guard let currentMovie,
              hasNextPage,
              !isLoading,
              movies.suffix(5).contains(where: { $0.id == currentMovie.id }) else {
            return
        }

        await loadPage(currentPage + 1, replacing: false)
    }

    private func loadPage(_ page: Int, replacing: Bool) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.upcomingMovies(page: page)
            currentPage = response.page
            hasNextPage = response.hasNextPage
            movies = replacing ? response.results : movies + response.results
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
