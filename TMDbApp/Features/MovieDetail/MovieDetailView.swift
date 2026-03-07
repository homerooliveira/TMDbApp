import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.movieService) private var movieService
    @State private var viewModel: MovieDetailViewModel?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let path = movie.posterPath,
                   let url = ImageEndpoint.poster(path: path).url {
                    KFImage(url)
                        .placeholder {
                            Image("placeholder")
                                .resizable()
                                .scaledToFit()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .frame(maxWidth: .infinity)
                }

                Text(movie.title)
                    .font(.title.bold())

                Text(movie.overview)
                    .foregroundStyle(.secondary)

                if let detail = viewModel?.detail {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Release Date: \(detail.releaseDate)")
                        Text("Genres: \(detail.genres.map(\.name).joined(separator: ", "))")
                    }
                    .foregroundStyle(.secondary)
                } else if viewModel?.isLoading == true {
                    ProgressView()
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            let vm = MovieDetailViewModel(movie: movie, service: movieService)
            viewModel = vm
            await vm.load()
        }
    }
}
