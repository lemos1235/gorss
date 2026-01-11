//
//  RSSService.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import Foundation
import FeedKit

enum RSSServiceError: Error {
    case invalidURL
    case parseError
}

class RSSService {
    static let shared = RSSService()
    
    private init() {}
    
    func fetchFeed(url: URL, sourceID: UUID? = nil) async throws -> [RSSItem] {
        let parser = FeedParser(URL: url)
        
        return try await withCheckedThrowingContinuation { continuation in
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
                switch result {
                case .success(let feed):
                    let items = self.mapFeedToItems(feed: feed, sourceID: sourceID)
                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 从 Feed 中提取图标 URL
    func extractIconURL(url: URL) async throws -> String? {
        let parser = FeedParser(URL: url)
        
        return try await withCheckedThrowingContinuation { continuation in
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
                switch result {
                case .success(let feed):
                    let iconUrl = self.extractFeedIcon(from: feed)
                    continuation.resume(returning: iconUrl)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 从不同类型的 Feed 中提取图标 URL
    private func extractFeedIcon(from feed: Feed) -> String? {
        switch feed {
        case .atom(let atomFeed):
            // Atom feed 支持 icon 和 logo 字段
            // 优先使用 icon (square icon)，其次是 logo
            return atomFeed.icon ?? atomFeed.logo
            
        case .rss(let rssFeed):
            // RSS feed 的 image 元素包含 URL
            return rssFeed.image?.url
            
        case .json(let jsonFeed):
            // JSON Feed 支持 favicon 和 icon
            // 优先使用 favicon (small square icon)，其次是 icon
            return jsonFeed.favicon ?? jsonFeed.icon
        }
    }
    
    private func mapFeedToItems(feed: Feed, sourceID: UUID? = nil) -> [RSSItem] {
        var rssItems: [RSSItem] = []
        
        switch feed {
        case .atom(let atomFeed):
            rssItems = atomFeed.entries?.compactMap { entry in
                guard let title = entry.title,
                      let updated = entry.updated else { return nil }
                
                let linkString = entry.links?.first?.attributes?.href
                let link = linkString != nil ? URL(string: linkString!) : nil
                let summary = entry.summary?.value ?? ""
                
                // Try to find image in links with enclosure type or extract from summary
                var imageUrl: URL?
                if let imageLink = entry.links?.first(where: { $0.attributes?.type?.hasPrefix("image") == true })?.attributes?.href {
                    imageUrl = URL(string: imageLink)
                }
                
                return RSSItem(
                    title: title,
                    summary: summary,
                    link: link,
                    pubDate: updated,
                    imageUrl: imageUrl,
                    sourceID: sourceID
                )
            } ?? []
            
        case .rss(let rssFeed):
            rssItems = rssFeed.items?.compactMap { item in
                guard let title = item.title,
                      let pubDate = item.pubDate else { return nil }
                
                let link = item.link != nil ? URL(string: item.link!) : nil
                let summary = item.description ?? ""
                
                // Try to find image in enclosure or extract from description/content
                var imageUrl: URL?
                if let enclosure = item.enclosure?.attributes?.url,
                   let type = item.enclosure?.attributes?.type,
                   type.hasPrefix("image") {
                    imageUrl = URL(string: enclosure)
                } else if let mediaContent = item.media?.mediaContents?.first?.attributes?.url {
                     imageUrl = URL(string: mediaContent)
                }
                
                return RSSItem(
                    title: title,
                    summary: summary,
                    link: link,
                    pubDate: pubDate,
                    imageUrl: imageUrl,
                    sourceID: sourceID
                )
            } ?? []
            
        case .json(let jsonFeed):
            rssItems = jsonFeed.items?.compactMap { item in
                guard let title = item.title,
                      let datePublished = item.datePublished else { return nil }
                
                let link = item.url != nil ? URL(string: item.url!) : nil
                let summary = item.summary ?? ""
                
                var imageUrl: URL?
                if let image = item.image {
                    imageUrl = URL(string: image)
                }
                
                return RSSItem(
                    title: title,
                    summary: summary,
                    link: link,
                    pubDate: datePublished,
                    imageUrl: imageUrl,
                    sourceID: sourceID
                )
            } ?? []
        }
        
        return rssItems.sorted(by: { $0.pubDate > $1.pubDate })
    }
}