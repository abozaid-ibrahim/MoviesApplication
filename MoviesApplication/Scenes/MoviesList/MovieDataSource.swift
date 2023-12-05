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

    func fetchMovies() async throws -> MovieResults
    func fetchMovieDetail(movieID: Int) async throws -> MovieDetails
}

/// Define a clear boundary for managing the network/API interactions and establishing the pagination configuration.
final class MovieAPIDataSource: MovieDataSource {
    let apiClient: APIClient
    private var currentPage = 0
    // TODO: Should be updated by the API, for now will set it to a default value 10
    private var totalPages = 10
    var fetchMoviesState: PaginationState = .idle

    init(apiClient: APIClient = NetworkAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchMovies() async throws -> MovieResults {
        currentPage += 1
        fetchMoviesState = .isLoading

        guard currentPage <= totalPages else {
            // No more pages to load
            fetchMoviesState = .error
            currentPage -= 1
            throw NetworkError.invalidURL
        }

        do {
            let movieData: MovieResults = try await apiClient.fetchData(for: EndPoint(path: "discover/movie", method: .get, parameters: ["page": currentPage]))
            fetchMoviesState = .idle
            return movieData
        } catch {
            currentPage -= 1
            fetchMoviesState = .error
            throw error
        }
    }

    func fetchMovieDetail(movieID: Int) async throws -> MovieDetails {
        do {
            return try await apiClient.fetchData(for: EndPoint(path: "movie/\(movieID)", method: .get, parameters: [:]))
        } catch {
            throw error
        }
    }
}
