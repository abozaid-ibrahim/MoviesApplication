//
//  MoviesListViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var cancellables: Set<AnyCancellable> = []
    private let dataSource: MovieDataSource

    init(dataSource: MovieDataSource = MovieAPIDataSource()) {
        self.dataSource = dataSource
    }

    var paginationState: PaginationState {
        return dataSource.fetchMoviesState
    }

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
