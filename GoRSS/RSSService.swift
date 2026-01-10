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
                } else {
                    imageUrl = extractImageURL(from: entry.content?.value) ?? extractImageURL(from: summary)
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
                } else {
                    imageUrl = extractImageURL(from: item.content?.contentEncoded) ?? extractImageURL(from: summary)
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
                } else {
                    imageUrl = extractImageURL(from: item.contentHtml) ?? extractImageURL(from: summary)
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
    
    // Helper to extract first image URL from HTML string
    private func extractImageURL(from html: String?) -> URL? {
        guard let html = html else { return nil }
        
        let pattern = "<img[^>]+src=\"([^\"]+)\""
        if let range = html.range(of: pattern, options: .regularExpression) {
            let match = html[range]
            if let range = match.range(of: "src=\"([^\"]+)\"", options: .regularExpression) {
                let srcAttribute = match[range]
                // Remove src=" and "
                let urlString = srcAttribute.dropFirst(5).dropLast()
                return URL(string: String(urlString))
            }
        }
        return nil
    }
}