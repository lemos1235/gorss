# GoRSS

GoRSS is a modern, lightweight RSS reader application built entirely with **SwiftUI**. It provides a clean and intuitive interface for managing your favorite news feeds, supporting RSS, Atom, and JSON formats.

## Features

- **Multi-Format Support**: Seamlessly parses RSS 2.0, Atom, and JSON Feed formats.
- **Feed Management**:
  - **Add Feeds**: Easily add new subscriptions with automatic URL validation.
  - **Edit Feeds**: Update feed URLs and rename subscriptions using the dedicated edit view.
  - **Auto-Sorting**: Subscription sources are automatically sorted alphabetically for easy navigation.
- **Article Organization**:
  - **Smart Filtering**: Filter articles by "All", "Starred", or specific feed sources.
  - **Read Status**: Tracks read/unread articles automatically.
  - **Favorites**: Star important articles to save them for later.
- **Modern UI**:
  - Built with SwiftUI for a fluid and responsive experience.
  - Integrated in-app browser (SafariView) for reading full articles.
  - Clean popover menus and smooth transitions.

## Requirements

- **iOS 17.0+**
- Swift 5.9+
- Xcode 15.0+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/lemos1235/gorss
   ```
2. Open the project in Xcode.
3. Wait for Swift Package Manager to resolve dependencies (specifically `FeedKit`).
4. Build and run on your simulator or device.

## Dependencies

- [FeedKit](https://github.com/nmdias/FeedKit): A robust RSS, Atom, and JSON Feed parser for Swift.

## Usage

1. **Adding a Feed**: Tap the menu button (top right) -> "My Feeds" -> "+" button. Enter the URL (e.g., `https://www.apple.com/newsroom/rss-feed.rss`).
2. **Editing a Feed**: Open the menu, long-press on a feed source, and select "Edit Feed" to change its name or URL.
3. **Reading**: Tap on any article card to open the full view. Use the star icon to save it to your favorites.

## License

This project is open source and available under the [MIT License](LICENSE).