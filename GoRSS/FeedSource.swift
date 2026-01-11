//
//  FeedSource.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import Foundation

struct FeedSource: Identifiable, Codable, Hashable {
    let id: UUID
    let url: URL
    var name: String?
    var iconUrl: String?
    let dateAdded: Date
    
    init(id: UUID = UUID(), url: URL, name: String? = nil, iconUrl: String? = nil, dateAdded: Date = Date()) {
        self.id = id
        self.url = url
        self.name = name
        self.iconUrl = iconUrl
        self.dateAdded = dateAdded
    }
}
