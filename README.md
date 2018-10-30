# TMDbApp

As the main challenge was to create a fully working app with pagination and search in a short period of time, the UI was not prioritized. The greatest effort was to focus on the architecture and best coding practices, so the MVVM architecture was a suitable option to abstract data and business rules.

## Instalation

Using terminal, go to the project folder where there is the Podfile and execute the command bellow.
``` sh
pod install
```
## Third-party libraries
- RxSwift. Used to easily manage asynchronous computing. Example: The request of movies in the search bar. 
- RxCocoa. Used to connect data from RxSwift to UIKit objects.
- Kingfisher. Used to download and cache images.

## Requirements
- iOS 11
- Xcode 10
- Swift 4.2
- CocoaPods
