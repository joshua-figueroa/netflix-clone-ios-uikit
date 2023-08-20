//
//  Youtube.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/19/23.
//

import Foundation

struct YoutubeResponse: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: PageInfo
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let kind, etag: String
    let id: ID
}

struct ID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
