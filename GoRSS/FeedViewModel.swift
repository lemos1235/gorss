//
//  FeedViewModel.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import Foundation

import SwiftUI

import Combine



final class FeedViewModel: ObservableObject {

    @Published var items: [RSSItem] = []

    @Published var sources: [FeedSource] = []

    @Published var isLoading = true

    @Published var errorMessage: String?
    
    @Published var readItemIDs: Set<String> = []
    @Published var starredItemIDs: Set<String> = []

    // MARK: - Filter
    enum FeedFilter: Equatable {
        case all
        case starred
        case source(FeedSource)
        
        static func == (lhs: FeedFilter, rhs: FeedFilter) -> Bool {
            switch (lhs, rhs) {
            case (.all, .all): return true
            case (.starred, .starred): return true
            case (.source(let s1), .source(let s2)): return s1.id == s2.id
            default: return false
            }
        }
    }
    
    @Published var selectedFilter: FeedFilter = .all
    
    var filteredItems: [RSSItem] {
        switch selectedFilter {
        case .all:
            return items
        case .starred:
            return items.filter { isStarred($0) }
        case .source(let source):
            return items.filter { $0.sourceID == source.id }
        }
    }


    private let sourcesKey = "saved_feed_sources"
    private let readStatusKey = "read_item_ids"
    private let starredStatusKey = "starred_item_ids"

    

    init() {

        loadSources()
        loadReadStatus()
        loadStarredStatus()

        // Add default source if empty

        if sources.isEmpty {

            addSource(url: URL(string: "https://www.apple.com/newsroom/rss-feed.rss")!, name: "Apple Newsroom")

        }

    }

    

    // MARK: - Feed Management

    private func sortSources() {
        sources.sort { (source1, source2) -> Bool in
            let name1 = source1.name ?? source1.url.absoluteString
            let name2 = source2.name ?? source2.url.absoluteString
            return name1.localizedStandardCompare(name2) == .orderedAscending
        }
    }

    func validateAndAddSource(url: URL, name: String? = nil) async throws {
        // Try to fetch to validate
        _ = try await RSSService.shared.fetchFeed(url: url)
        
        // If success, add it
        await MainActor.run {
            let newSource = FeedSource(url: url, name: name)
            sources.append(newSource)
            sortSources()
            saveSources()
        }
        
        await loadAllFeeds()
    }

    func addSource(url: URL, name: String? = nil) {

        let newSource = FeedSource(url: url, name: name)

        sources.append(newSource)
        sortSources()

        saveSources()

        Task { await loadAllFeeds() }

    }
    
    func moveSource(from source: IndexSet, to destination: Int) {
        sources.move(fromOffsets: source, toOffset: destination)
        saveSources()
    }
    
    func updateSource(_ source: FeedSource, newName: String, newUrl: URL? = nil) async throws {
        if let index = sources.firstIndex(where: { $0.id == source.id }) {
            var updatedSource = sources[index]
            updatedSource.name = newName
            
            // If URL is changing, we might want to validate it first or just update it.
            // Assuming validation happens before calling this function or we do it here.
            if let newUrl = newUrl, newUrl != source.url {
                // Validate new URL
                _ = try await RSSService.shared.fetchFeed(url: newUrl)
                
                // Create new source with new URL but same ID (to keep user preference if possible, 
                // but ID is UUID, so it's fine. 
                // However, `url` is `let` in FeedSource. We need to create a new struct.)
                updatedSource = FeedSource(id: source.id, url: newUrl, name: newName, dateAdded: source.dateAdded)
                
                // Since URL changed, we should reload feeds
                sources[index] = updatedSource
                sortSources()
                saveSources()
                await loadAllFeeds()
            } else {
                // Only name changed
                sources[index] = updatedSource
                sortSources()
                saveSources()
            }
        }
    }
    
    func deleteSource(_ source: FeedSource) {
        if let index = sources.firstIndex(where: { $0.id == source.id }) {
            sources.remove(at: index)
            saveSources()
            
            // If the deleted source was selected, switch to 'all'
            if case .source(let selectedSource) = selectedFilter, selectedSource.id == source.id {
                selectedFilter = .all
            }
            
            Task { await loadAllFeeds() }
        }
    }

    

    func removeSource(at offsets: IndexSet) {

        sources.remove(atOffsets: offsets)

        saveSources()

        Task { await loadAllFeeds() }

    }

    

    private func saveSources() {

        if let encoded = try? JSONEncoder().encode(sources) {

            UserDefaults.standard.set(encoded, forKey: sourcesKey)

        }

    }

    

    private func loadSources() {

        if let data = UserDefaults.standard.data(forKey: sourcesKey),

           let decoded = try? JSONDecoder().decode([FeedSource].self, from: data) {

            sources = decoded
            sortSources()

        }

    }
    
    // MARK: - Read Status Management
    
    func isRead(_ item: RSSItem) -> Bool {
        // Use link as primary ID, fallback to title
        let id = item.link?.absoluteString ?? item.title
        return readItemIDs.contains(id)
    }

    func markAsRead(_ item: RSSItem) {
        let id = item.link?.absoluteString ?? item.title
        if !readItemIDs.contains(id) {
            readItemIDs.insert(id)
            saveReadStatus()
        }
    }
    
    func markAllAsRead() {
        for item in items {
            let id = item.link?.absoluteString ?? item.title
            readItemIDs.insert(id)
        }
        saveReadStatus()
    }
    
    func clearReadStatus() {
        readItemIDs.removeAll()
        saveReadStatus()
    }
    
    func clearStarredStatus() {
        starredItemIDs.removeAll()
        saveStarredStatus()
    }

    // MARK: - Starred Management
    
    func isStarred(_ item: RSSItem) -> Bool {
        let id = item.link?.absoluteString ?? item.title
        return starredItemIDs.contains(id)
    }
    
    func toggleStar(_ item: RSSItem) {
        let id = item.link?.absoluteString ?? item.title
        if starredItemIDs.contains(id) {
            starredItemIDs.remove(id)
        } else {
            starredItemIDs.insert(id)
        }
        saveStarredStatus()
    }
    
    private func saveStarredStatus() {
        if let encoded = try? JSONEncoder().encode(starredItemIDs) {
            UserDefaults.standard.set(encoded, forKey: starredStatusKey)
        }
    }
    
    private func loadStarredStatus() {
        if let data = UserDefaults.standard.data(forKey: starredStatusKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            starredItemIDs = decoded
        }
    }

    private func saveReadStatus() {
        if let encoded = try? JSONEncoder().encode(readItemIDs) {
            UserDefaults.standard.set(encoded, forKey: readStatusKey)
        }
    }

    private func loadReadStatus() {
        if let data = UserDefaults.standard.data(forKey: readStatusKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            readItemIDs = decoded
        }
    }

    

    // MARK: - Fetching

    

    @MainActor
    func loadAllFeeds() async {
        guard !sources.isEmpty else {
            items = []
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Concurrent fetching using TaskGroup
            let allItems: [RSSItem] = try await withThrowingTaskGroup(of: [RSSItem].self) { group in
                for source in sources {
                    group.addTask {
                        return try await RSSService.shared.fetchFeed(url: source.url, sourceID: source.id)
                    }
                }
                
                var results: [RSSItem] = []
                for try await feedItems in group {
                    results.append(contentsOf: feedItems)
                }
                return results
            }
            
            // Sort by date (newest first)
            let sortedItems = allItems.sorted { item1, item2 in
                return item1.pubDate > item2.pubDate
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.items = sortedItems
            }
        } catch {
            errorMessage = "部分源更新失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }

}
