import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    let movie: Movie
    var detail: MovieDetail?
    var isLoading = false

    private let service: any MovieService

    init(movie: Movie, service: any MovieService) {
        self.movie = movie
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            detail = try await service.fetchMovieDetail(id: movie.id)
        } catch {
            // detail stays nil on error
        }
    }
}
