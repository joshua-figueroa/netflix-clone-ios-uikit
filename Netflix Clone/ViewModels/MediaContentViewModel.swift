//
//  MediaContentViewModel.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/16/23.
//

import Foundation

struct MediaContentViewModel {
    let poster: String
    let title: String
    
    init(poster: String, title: String) {
        self.poster = poster
        self.title = title
    }
}
