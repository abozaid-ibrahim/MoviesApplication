//
//  MovieService.swift
//  MoviesApplication
//
//  Created by abuzeid on 30.11.23.
//

import Combine
import Foundation

final class MovieService {
    private let api = MovieAPIClient()
    private var currentPage = 0
    // TODO: Should be updated by the API, for now will set it to a default value 5
    private var totalPages = 15
    private(set) var fetchMoviesState: PaginationState = .idle

    func fetchMovies() -> AnyPublisher<MovieResults, Error> {
        currentPage += 1
        fetchMoviesState = .isLoading
        guard currentPage <= totalPages else {
            // No more pages to load
            fetchMoviesState = .error
            currentPage -= 1
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return api.fetchData(for: EndPoint(path: "discover/movie", method: .get, parameters: ["page": currentPage]))
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
        return api.fetchData(for: EndPoint(path: "movie/\(movieID)", method: .get, parameters: [:]))
    }
}
