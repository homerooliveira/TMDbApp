import SwiftUI

@main
struct TMDbAppApp: App {
    private let service: (any MovieServicing)?
    private let configurationError: String?

    init() {
        do {
            let configuration = try AppConfiguration.load()
            self.service = LiveMovieService(configuration: configuration)
            self.configurationError = nil
        } catch {
            self.service = nil
            self.configurationError = error.localizedDescription
        }
    }

    var body: some Scene {
        WindowGroup {
            if let service {
                RootTabView(service: service)
            } else {
                ConfigurationErrorView(message: configurationError ?? "Missing configuration")
            }
        }
    }
}
