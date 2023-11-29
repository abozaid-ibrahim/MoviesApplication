//
//  MovieDetailsViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation


extension MoviesListViewModel {
    func posterURL(for path: String?) -> URL? {
        guard let path = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        return URL(string: baseURL + path)
    }
}
