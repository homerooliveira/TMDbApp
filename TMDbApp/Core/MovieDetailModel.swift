import Foundation
import Observation

@MainActor
@Observable
public final class MovieDetailModel {
    public let movie: Movie
    public private(set) var details: MovieDetails?
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?

    @ObservationIgnored private let service: any MovieServicing

    public init(movie: Movie, service: any MovieServicing) {
        self.movie = movie
        self.service = service
    }

    public func loadIfNeeded() async {
        guard details == nil, !isLoading else { return }
        await reload()
    }

    public func reload() async {
        isLoading = true
        errorMessage = nil

        do {
            details = try await service.movieDetails(id: movie.id)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
