//
//  MovieDetails.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation

struct MovieDetails: Codable {
    let title: String
    let overview: String
    let releaseDate: Date
    let posterPath: String?
}
