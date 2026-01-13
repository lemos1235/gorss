# GoRSS Project Context

## Project Overview
**GoRSS** is a modern, lightweight RSS reader application built with **SwiftUI** for iOS. It supports RSS, Atom, and JSON Feed formats.

## Tech Stack
- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Platform**: iOS 17.0+
- **Dependencies**:
    - [FeedKit](https://github.com/nmdias/FeedKit) (v9.1.2) - Used for parsing RSS/Atom/JSON feeds.
- **Build System**: Xcode Project with Swift Package Manager for dependencies.

## Architecture
The project follows the **MVVM (Model-View-ViewModel)** pattern:
- **Models**: `RSSItem`, `FeedSource` (Data structures).
- **ViewModels**: `FeedViewModel` (State management, bridging UI and Service).
- **Services**: `RSSService` (Business logic, networking, parsing via FeedKit).
- **Views**: `ContentView`, `AddFeedView`, `EditFeedView` (UI components).

## Key Files
- **`GoRSS/GoRSSApp.swift`**: Application entry point.
- **`GoRSS/RSSService.swift`**: Core service class handling feed fetching and parsing using `FeedKit`. Handles image/icon extraction.
- **`Package.swift`**: Defines the `GoRSSCore` library target and dependencies (`FeedKit`). Note that UI files are excluded from this package target, implying they are part of the main App target in the `.xcodeproj`.
- **`GoRSS/FeedViewModel.swift`**: (Inferred) Manages the feed state and logic for the views.
- **`GoRSS/RSSItem.swift`**: Model representing a single news article.

## Development Conventions
- **SwiftUI**: Uses modern SwiftUI patterns (`@main`, `WindowGroup`, etc.).
- **Async/Await**: Network calls in `RSSService` utilize Swift Concurrency (`async/await`).
- **Dependency Management**: Uses Swift Package Manager (SPM).

## Build & Run
1. Open `GoRSS.xcodeproj` in Xcode 15.0+.
2. Ensure package dependencies are resolved.
3. Select an iOS Simulator (iOS 17+).
4. Run (`Cmd+R`).
