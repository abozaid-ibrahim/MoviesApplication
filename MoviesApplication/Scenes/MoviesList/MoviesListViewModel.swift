//
//  MoviesListViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

/// The view model for the Movies List screen.
import Foundation

final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let dataSource: MovieDataSource

    init(dataSource: MovieDataSource = MovieAPIDataSource()) {
        self.dataSource = dataSource
    }

    var paginationState: PaginationState {
        return dataSource.fetchMoviesState
    }

    func fetchMovies() {
        Task {
            do {
                let result = try await dataSource.fetchMovies()
                DispatchQueue.main.async {
                    self.movies += result.results
                }
            } catch {
                // TODO: error handling
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func display(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    func posterURL(for path: String?) -> URL? {
        guard let pathValue = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w200/"
        return URL(string: baseURL + pathValue)
    }
}
