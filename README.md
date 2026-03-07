# TMDbApp

TMDbApp is now a modern Swift 6 movie browser built with SwiftUI, Swift Concurrency, Swift Testing, and Swift Package Manager for the shared core module.

## Requirements

- Xcode 16+
- iOS 17+
- Swift 6

## Configuration

The app includes the same TMDb API key in source as the legacy project.

You can still override it in one of these ways:

1. Add `TMDB_API_KEY` to the app scheme environment variables.
2. Or add `TMDB_API_KEY` to `TMDbApp/Info.plist` for local development.

## Project Layout

- `TMDbApp/App`: SwiftUI app and screens
- `TMDbApp/Core`: package-backed shared logic, networking, and observable models
- `Tests/TMDbCoreTests`: Swift Testing coverage

## Development

Run package tests:

```sh
swift test
```

Open `TMDbApp.xcodeproj` in Xcode to run the iOS app.
