import SwiftUI

struct UpcomingMoviesView: View {
    let viewModel: UpcomingMoviesViewModel

    var body: some View {
        List(viewModel.movies) { movie in
            NavigationLink(value: movie) {
                MovieRowView(movie: movie)
                    .onAppear {
                        Task { await viewModel.loadNextPageIfNeeded(currentItem: movie) }
                    }
            }
        }
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
        .overlay {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadFirstPage()
        }
    }
}
