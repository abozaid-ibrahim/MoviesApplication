//
//  MovieDetailsViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

final class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    @Published var error: Error?

    private var cancellables: Set<AnyCancellable> = []
    private let dataSource: MovieDataSource

    init(dataSource: MovieDataSource = MovieAPIDataSource()) {
        self.dataSource = dataSource
    }

    func fetchMovieDetail(movieID: Int) async {
        do {
            let movieDetail = try await dataSource.fetchMovieDetail(movieID: movieID)
            await MainActor.run {
                self.movieDetails = movieDetail
            }
        } catch {
            self.error = error
        }
    }

    var dateDisplay: String {
        guard let currentDate = movieDetails?.releaseDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: currentDate)
    }

    func posterURL(for path: String?) -> URL? {
        guard let pathValue = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        return URL(string: baseURL + pathValue)
    }
}
