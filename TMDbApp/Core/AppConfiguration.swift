import Foundation

public struct AppConfiguration: Equatable, Sendable {
    public static let embeddedAPIKey = "c5850ed73901b8d268d0898a8a9d8bff"

    public let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public static func load(
        bundle: Bundle = .main,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) throws -> AppConfiguration {
        if let apiKey = environment["TMDB_API_KEY"]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !apiKey.isEmpty {
            return AppConfiguration(apiKey: apiKey)
        }

        if let apiKey = bundle.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
           !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return AppConfiguration(apiKey: apiKey)
        }

        return AppConfiguration(apiKey: embeddedAPIKey)
    }
}

public enum AppConfigurationError: LocalizedError, Equatable, Sendable {
    case missingAPIKey

    public var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "TMDB_API_KEY is missing. Add it to the environment or Info.plist."
        }
    }
}
