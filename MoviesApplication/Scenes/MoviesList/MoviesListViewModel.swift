//
//  MoviesListViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

/// The view model for the Movies List screen.
final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var cancellables: Set<AnyCancellable> = []
    private let dataSource: MovieDataSource

    /// Initializes a new instance of the view model.
    /// - Parameter dataSource: The data source used to fetch movies. Defaults to `MovieAPIDataSource`.
    init(dataSource: MovieDataSource = MovieAPIDataSource()) {
        self.dataSource = dataSource
    }

    /// The current pagination state of the movies list.
    var paginationState: PaginationState {
        return dataSource.fetchMoviesState
    }

    /// Fetches movies from the data source.
    func fetchMovies() {
        dataSource.fetchMovies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { result in
                self.movies += result.results
            })
            .store(in: &cancellables)
    }

    /// Displays the year of a given date.
    /// - Parameter date: The date to display.
    /// - Returns: The year in string format.
    func display(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    /// Generates the URL for a movie poster image.
    /// - Parameter path: The path of the poster image.
    /// - Returns: The URL of the poster image.
    func posterURL(for path: String?) -> URL? {
        guard let pathValue = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w200/"
        return URL(string: baseURL + pathValue)
    }
}
