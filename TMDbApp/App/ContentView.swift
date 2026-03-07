import SwiftUI

struct RootTabView: View {
    let service: any MovieServicing

    var body: some View {
        TabView {
            NavigationStack {
                UpcomingMoviesView(service: service)
            }
            .tabItem {
                Label("Upcoming", systemImage: "film")
            }

            NavigationStack {
                SearchMoviesView(service: service)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .tint(.red)
    }
}

struct ConfigurationErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.slash")
                .font(.system(size: 40))
            Text("Missing TMDb Configuration")
                .font(.title2.bold())
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text("Set TMDB_API_KEY in the scheme environment or Info.plist.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.black, .red.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .foregroundStyle(.white)
    }
}

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: MovieEndpoint.posterURL(path: movie.posterPath)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(.white.opacity(0.08))
                    .overlay {
                        Image(systemName: "film")
                            .foregroundStyle(.white.opacity(0.6))
                    }
            }
            .frame(width: 72, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(movie.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
    }
}
