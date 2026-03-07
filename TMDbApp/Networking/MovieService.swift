import Foundation
import SwiftUI

protocol MovieService: Sendable {
    func fetchUpcomingMovies(page: Int) async throws -> Page<Movie>
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func searchMovies(query: String) async throws -> Page<Movie>
}

private struct MovieServiceKey: EnvironmentKey {
    static let defaultValue: any MovieService = TMDbMovieService()
}

extension EnvironmentValues {
    var movieService: any MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }
}
