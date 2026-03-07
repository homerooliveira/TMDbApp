import Testing
import Foundation
@testable import TMDbApp

@Suite("TMDbEndpoint")
struct TMDbEndpointTests {

    @Test("upcomingMovies URL contains correct path")
    func upcomingMoviesURLPath() throws {
        let url = try TMDbEndpoint.upcomingMovies(page: 1).url()
        #expect(url.path.contains("/movie/upcoming"))
    }

    @Test("upcomingMovies URL contains page parameter")
    func upcomingMoviesURLPageParam() throws {
        let url = try TMDbEndpoint.upcomingMovies(page: 3).url()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let page = components.queryItems?.first(where: { $0.name == "page" })?.value
        #expect(page == "3")
    }

    @Test("movieDetail URL contains movie ID in path")
    func movieDetailURLContainsID() throws {
        let url = try TMDbEndpoint.movieDetail(id: 550).url()
        #expect(url.path.contains("/movie/550"))
    }

    @Test("searchMovies URL contains query parameter")
    func searchMoviesURLContainsQuery() throws {
        let url = try TMDbEndpoint.searchMovies(query: "inception").url()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let query = components.queryItems?.first(where: { $0.name == "query" })?.value
        #expect(query == "inception")
    }

    @Test("searchMovies URL handles spaces in query")
    func searchMoviesURLEncodesSpaces() throws {
        let url = try TMDbEndpoint.searchMovies(query: "star wars").url()
        #expect(!url.absoluteString.contains(" "))
    }

    @Test("all endpoints include API key")
    func allEndpointsIncludeAPIKey() throws {
        let urls = [
            try TMDbEndpoint.upcomingMovies(page: 1).url(),
            try TMDbEndpoint.movieDetail(id: 1).url(),
            try TMDbEndpoint.searchMovies(query: "test").url()
        ]
        for url in urls {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            let hasAPIKey = components.queryItems?.contains(where: { $0.name == "api_key" }) ?? false
            #expect(hasAPIKey, "URL \(url) should contain api_key")
        }
    }
}
