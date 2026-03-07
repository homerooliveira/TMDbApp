import Foundation
import Observation

@MainActor
@Observable
final class SearchMoviesViewModel {
    var searchText = ""
    var movies: [Movie] = []
    var isLoading = false

    private var searchTask: Task<Void, Never>?
    private let service: any MovieService

    init(service: any MovieService) {
        self.service = service
    }

    func searchTextChanged(_ text: String) {
        searchText = text
        searchTask?.cancel()

        guard !text.isEmpty else {
            movies = []
            return
        }

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await performSearch(query: text)
        }
    }

    private func performSearch(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await service.searchMovies(query: query)
            guard !Task.isCancelled else { return }
            movies = page.results
        } catch is CancellationError {
            // Expected when a new search cancels the previous one
        } catch {
            movies = []
        }
    }
}
