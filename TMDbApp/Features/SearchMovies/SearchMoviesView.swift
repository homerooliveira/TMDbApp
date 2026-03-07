import SwiftUI

struct SearchMoviesView: View {
    let viewModel: SearchMoviesViewModel

    var body: some View {
        List(viewModel.movies) { movie in
            NavigationLink(value: movie) {
                MovieRowView(movie: movie)
            }
        }
        .searchable(
            text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.searchTextChanged($0) }
            ),
            prompt: "Search name or partial name"
        )
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.movies.isEmpty && !viewModel.searchText.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
            } else if viewModel.movies.isEmpty {
                ContentUnavailableView(
                    "Search for Movies",
                    systemImage: "magnifyingglass",
                    description: Text("Enter a movie name to search")
                )
            }
        }
    }
}
