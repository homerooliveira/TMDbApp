import SwiftUI

struct SearchMoviesView: View {
    @State private var searchText = ""
    @State private var model: SearchMoviesModel
    let service: any MovieServicing

    init(service: any MovieServicing) {
        self.service = service
        _model = State(initialValue: SearchMoviesModel(service: service))
    }

    var body: some View {
        List {
            if searchText.isEmpty {
                ContentUnavailableView("Search TMDb", systemImage: "magnifyingglass", description: Text("Type a movie title to start searching."))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if model.isSearching && model.movies.isEmpty {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if let message = model.errorMessage {
                ErrorBanner(message: message) {
                    model.updateQuery(searchText)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else if model.movies.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(model.movies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie, service: service)
                    } label: {
                        MovieRowView(movie: movie)
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Search")
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                colors: [.black, .orange.opacity(0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Movie title")
        .onChange(of: searchText) { _, newValue in
            model.updateQuery(newValue)
        }
    }
}
