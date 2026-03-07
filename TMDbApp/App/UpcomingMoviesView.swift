import SwiftUI

struct UpcomingMoviesView: View {
    @State private var model: UpcomingMoviesModel
    let service: any MovieServicing

    init(service: any MovieServicing) {
        self.service = service
        _model = State(initialValue: UpcomingMoviesModel(service: service))
    }

    var body: some View {
        List {
            if let errorMessage {
                ErrorBanner(message: errorMessage) {
                    Task { await model.refresh() }
                }
                .listRowSeparator(.hidden)
            }

            ForEach(model.movies) { movie in
                NavigationLink {
                    MovieDetailView(movie: movie, service: service)
                } label: {
                    MovieRowView(movie: movie)
                }
                .listRowBackground(Color.clear)
                .task {
                    await model.loadNextPageIfNeeded(currentMovie: movie)
                }
            }

            if model.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Upcoming Movies")
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                colors: [.black, .red.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .task {
            await model.loadInitialPageIfNeeded()
        }
        .refreshable {
            await model.refresh()
        }
    }

    private var errorMessage: String? {
        model.movies.isEmpty ? model.errorMessage : nil
    }
}

struct ErrorBanner: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .multilineTextAlignment(.center)
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}
