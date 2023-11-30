//
//  MoviesListViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import Combine

//TODO:
//pagination

class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
    var paginationState: PaginationState{
        return movieService.fetchMoviesState
    }
    func fetchMovies() {
        movieService.fetchMovies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { result in
                self.movies += result.results
            })
            .store(in: &cancellables)
    }
    func display(date: Date)->String{
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // Set the desired format to extract the year

      return dateFormatter.string(from: date)
    }
    func posterURL(for path: String?) -> URL? {
        guard let path = path else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w200/"
        return URL(string: baseURL + path)
    }
   
}

