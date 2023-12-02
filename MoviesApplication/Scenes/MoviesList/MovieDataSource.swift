//
//  MovieDataSource.swift
//  MoviesApplication
//
//  Created by abuzeid on 30.11.23.
//

import Combine
import Foundation

protocol MovieDataSource {
    var fetchMoviesState: PaginationState { get }

    func fetchMovies() -> AnyPublisher<MovieResults, Error>
    func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetails, Error>
}

/// Define a clear boundary for managing the network/API interactions and establishing the pagination configuration.
final class MovieAPIDataSource: MovieDataSource {
    let apiClient: APIClient
    private var currentPage = 0
    // TODO: Should be updated by the API, for now will set it to a default value 10
    private var totalPages = 10
    var fetchMoviesState: PaginationState = .idle

    init(apiClient: APIClient = MovieAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchMovies() -> AnyPublisher<MovieResults, Error> {
        currentPage += 1
        fetchMoviesState = .isLoading
        guard currentPage <= totalPages else {
            // No more pages to load
            fetchMoviesState = .error
            currentPage -= 1
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return apiClient.fetchData(for: EndPoint(path: "discover/movie", method: .get, parameters: ["page": currentPage]))
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .handleEvents(receiveCompletion: { [weak self] completion in
                guard let strongSelf = self else { return }
                switch completion {
                case .finished:
                    strongSelf.fetchMoviesState = .idle
                case .failure:
                    strongSelf.currentPage -= 1
                    strongSelf.fetchMoviesState = .error
                }
            })
            .eraseToAnyPublisher()
    }

    func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetails, Error> {
        return apiClient.fetchData(for: EndPoint(path: "movie/\(movieID)", method: .get, parameters: [:]))
    }
}
