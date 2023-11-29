//
//  Movie.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String // Assuming this is the release date
    // Add more properties as needed

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

struct MovieResults: Codable {
    let results: [Movie]
}

