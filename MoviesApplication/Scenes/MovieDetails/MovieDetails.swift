//
//  MovieDetails.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation

struct MovieDetail: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    // Add more properties as needed

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
