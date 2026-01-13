//
//  RSSItem.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import Foundation

struct RSSItem: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    let title: String
    let summary: String
    let link: URL?
    let pubDate: Date
    let imageUrl: URL? // Add this property
    let sourceID: UUID?

    init(id: UUID = UUID(), title: String, summary: String, link: URL?, pubDate: Date, imageUrl: URL? = nil, sourceID: UUID? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.link = link
        self.pubDate = pubDate
        self.imageUrl = imageUrl
        self.sourceID = sourceID
    }
}
