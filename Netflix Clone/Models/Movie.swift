//
//  Movie.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/14/23.
//

import Foundation

struct MediaContentResponse: Codable {
    let page: Int
    let results: [MediaContent]
    let total_pages: Int
    let total_results: Int
}

struct MediaContent: Identifiable, Codable {
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let title: String?
    let name: String?
    let original_language: String
    let original_title: String?
    let original_name: String?
    let overview: String
    let poster_path: String?
    let media_type: String?
    let genre_ids: [Int]
    let popularity: Double
    let release_date: String?
    let first_air_date: String?
    let video: Bool?
    let vote_average: Double
    let vote_count: Int
    let origin_country: [String]?
}
