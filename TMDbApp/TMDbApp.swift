import SwiftUI

@main
struct TMDbApp: App {
    private let service = TMDbMovieService()

    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
        }
    }
}

struct ContentView: View {
    @State private var upcomingViewModel: UpcomingMoviesViewModel
    @State private var searchViewModel: SearchMoviesViewModel
    private let service: any MovieService

    init(service: any MovieService) {
        self.service = service
        _upcomingViewModel = State(initialValue: UpcomingMoviesViewModel(service: service))
        _searchViewModel = State(initialValue: SearchMoviesViewModel(service: service))
    }

    var body: some View {
        TabView {
            NavigationStack {
                UpcomingMoviesView(viewModel: upcomingViewModel)
                    .navigationTitle("Upcoming Movies")
            }
            .tabItem { Label("Upcoming", systemImage: "film") }

            NavigationStack {
                SearchMoviesView(viewModel: searchViewModel)
                    .navigationTitle("Search Movies")
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
        .environment(\.movieService, service)
    }
}
