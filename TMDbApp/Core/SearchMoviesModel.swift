import Foundation
import Observation

@MainActor
@Observable
public final class SearchMoviesModel {
    public var query = ""
    public private(set) var movies: [Movie] = []
    public private(set) var isSearching = false
    public private(set) var errorMessage: String?

    @ObservationIgnored private let service: any MovieServicing
    @ObservationIgnored private var searchTask: Task<Void, Never>?

    public init(service: any MovieServicing) {
        self.service = service
    }

    deinit {
        searchTask?.cancel()
    }

    public func updateQuery(_ value: String) {
        query = value
        searchTask?.cancel()

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            movies = []
            errorMessage = nil
            isSearching = false
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await self?.runSearch(for: trimmed)
        }
    }

    private func runSearch(for query: String) async {
        isSearching = true
        errorMessage = nil

        do {
            let response = try await service.searchMovies(query: query)
            guard !Task.isCancelled else { return }
            movies = response.results
        } catch {
            guard !Task.isCancelled else { return }
            movies = []
            errorMessage = error.localizedDescription
        }

        isSearching = false
    }
}
