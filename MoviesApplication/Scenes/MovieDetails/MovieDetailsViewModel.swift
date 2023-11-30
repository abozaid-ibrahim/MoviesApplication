//
//  MovieDetailsViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation

import Foundation
import Combine


class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetail?
    
    private var cancellables: Set<AnyCancellable> = []
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
  
    func fetchMovieDetail(movieID: Int, completion: @escaping (MovieDetail) -> Void) {
        movieService.fetchMovieDetail(movieID: movieID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { movieDetail in
                self.movieDetails = movieDetail
                completion(movieDetail)
            })
            .store(in: &cancellables)
    }
}



extension MovieDetailsViewModel {
    func posterURL(for path: String?) -> URL? {
        guard let path = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500/"
//        print(">>> \(URL(string: baseURL + path))")
        return URL(string: baseURL + path)
    }
}
