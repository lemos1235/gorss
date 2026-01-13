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
    // MARK: - Published Properties
    @Published var items: [RSSItem] = []
    @Published var sources: [FeedSource] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var readItemIDs: Set<String> = []
    @Published var starredItemIDs: Set<String> = []
    @Published var selectedFilter: FeedFilter = .all

    // MARK: - Constants & Keys
    private let sourcesKey = "saved_feed_sources"
    private let readStatusKey = "read_item_ids"
    private let starredStatusKey = "starred_item_ids"
    private let itemsFileName = "saved_rss_items.json"
    
    private var itemsFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(itemsFileName)
    }

    // MARK: - Filter Type
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

    // MARK: - Initialization
    init() {
        loadSources()
        loadReadStatus()
        loadStarredStatus()
        loadItems()
    }

    // MARK: - Feed Fetching
    @MainActor
    func loadAllFeeds() async {
        guard !sources.isEmpty else {
            if items.isEmpty { isLoading = false }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newItems: [RSSItem] = try await withThrowingTaskGroup(of: [RSSItem].self) { group in
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
            
            var currentItemsDict = Dictionary(uniqueKeysWithValues: items.map { ($0.link?.absoluteString ?? $0.title, $0) })
            var mergedItems: [RSSItem] = []
            
            for newItem in newItems {
                let key = newItem.link?.absoluteString ?? newItem.title
                if let existingItem = currentItemsDict[key] {
                    let updatedItem = RSSItem(
                        id: existingItem.id,
                        title: newItem.title,
                        summary: newItem.summary,
                        link: newItem.link,
                        pubDate: newItem.pubDate,
                        imageUrl: newItem.imageUrl,
                        sourceID: newItem.sourceID
                    )
                    mergedItems.append(updatedItem)
                    currentItemsDict.removeValue(forKey: key)
                } else {
                    mergedItems.append(newItem)
                }
            }
            
            mergedItems.append(contentsOf: currentItemsDict.values)
            let sortedItems = mergedItems.sorted { $0.pubDate > $1.pubDate }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.items = sortedItems
            }
            self.saveItems()
        } catch {
            errorMessage = "部分源更新失败: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: - Source Management
    func validateAndAddSource(url: URL, name: String? = nil) async throws {
        _ = try await RSSService.shared.fetchFeed(url: url)
        let iconUrl = try? await RSSService.shared.extractIconURL(url: url)
        
        await MainActor.run {
            let newSource = FeedSource(url: url, name: name, iconUrl: iconUrl)
            sources.append(newSource)
            sortSources()
            saveSources()
        }
        await loadAllFeeds()
    }
    
    func updateSource(_ source: FeedSource, newName: String, newUrl: URL? = nil) async throws {
        if let index = sources.firstIndex(where: { $0.id == source.id }) {
            var updatedSource = sources[index]
            updatedSource.name = newName
            
            if let newUrl = newUrl, newUrl != source.url {
                _ = try await RSSService.shared.fetchFeed(url: newUrl)
                let iconUrl = try? await RSSService.shared.extractIconURL(url: newUrl)
                updatedSource = FeedSource(id: source.id, url: newUrl, name: newName, iconUrl: iconUrl, dateAdded: source.dateAdded)
                
                sources[index] = updatedSource
                sortSources()
                saveSources()
                await loadAllFeeds()
            } else {
                let iconUrl = try? await RSSService.shared.extractIconURL(url: source.url)
                updatedSource = FeedSource(id: source.id, url: source.url, name: newName, iconUrl: iconUrl, dateAdded: source.dateAdded)
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
    
    func moveSource(from source: IndexSet, to destination: Int) {
        sources.move(fromOffsets: source, toOffset: destination)
        saveSources()
    }

    private func sortSources() {
        sources.sort { (source1, source2) -> Bool in
            let name1 = source1.name ?? source1.url.absoluteString
            let name2 = source2.name ?? source2.url.absoluteString
            return name1.localizedStandardCompare(name2) == .orderedAscending
        }
    }

    // MARK: - Read Status
    func isRead(_ item: RSSItem) -> Bool {
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

    // MARK: - Starred Status
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

    func clearStarredStatus() {
        starredItemIDs.removeAll()
        saveStarredStatus()
    }

    // MARK: - Cache Management
    func clearCache() {
        items = items.filter { isStarred($0) }
        saveItems()
    }

    // MARK: - Persistence Helpers
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
    
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: itemsFileURL)
        } catch {
            print("Failed to save items: \(error)")
        }
    }
    
    private func loadItems() {
        do {
            let data = try Data(contentsOf: itemsFileURL)
            let decoded = try JSONDecoder().decode([RSSItem].self, from: data)
            items = decoded
        } catch {
            print("Failed to load items: \(error)")
        }
    }
}