import SwiftUI
import Kingfisher

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            Group {
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
                } else {
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 50, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(movie.title)
                .font(.body)
                .lineLimit(2)

            Spacer()
        }
    }
}
