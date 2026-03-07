import SwiftUI

struct MovieDetailView: View {
    @State private var model: MovieDetailModel

    init(movie: Movie, service: any MovieServicing) {
        _model = State(initialValue: MovieDetailModel(movie: movie, service: service))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: MovieEndpoint.posterURL(path: model.movie.posterPath)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.white.opacity(0.08))
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                VStack(alignment: .leading, spacing: 12) {
                    Text(model.movie.title)
                        .font(.largeTitle.bold())
                    Label(model.details?.releaseDate ?? model.movie.releaseDate, systemImage: "calendar")
                        .foregroundStyle(.secondary)
                    if let genres = model.details?.genres, !genres.isEmpty {
                        Text(genres.map(\.name).joined(separator: " • "))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                Text(model.details?.overview ?? model.movie.overview)
                    .font(.body)
                    .foregroundStyle(.primary)

                if let errorMessage = model.errorMessage {
                    ErrorBanner(message: errorMessage) {
                        Task { await model.reload() }
                    }
                }
            }
            .padding(20)
        }
        .background(
            LinearGradient(
                colors: [.black, .indigo.opacity(0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.loadIfNeeded()
        }
    }
}
