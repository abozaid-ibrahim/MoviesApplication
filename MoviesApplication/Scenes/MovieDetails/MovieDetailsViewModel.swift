//
//  MovieDetailsViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?

    private var cancellables: Set<AnyCancellable> = []
    private let movieService: MovieService

    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }

    func fetchMovieDetail(movieID: Int, completion: @escaping (MovieDetails) -> Void) {
        movieService.fetchMovieDetail(movieID: movieID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { movieDetail in
                self.movieDetails = movieDetail
                completion(movieDetail)
            })
            .store(in: &cancellables)
    }

    var dateDisplay: String {
        guard let currentDate = movieDetails?.releaseDate else { return "" }
        // Create a date formatter
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
