//
//  MoviesListViewModel.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import Combine


import SwiftUI
import Combine
//TODO:
//pagination

class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchMovies() {
        let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResults.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { result in
                self.movies = result.results
            })
            .store(in: &cancellables)
    }
    
    func fetchMovieDetail(movieID: Int, completion: @escaping (MovieDetail) -> Void) {
        let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { movieDetail in
                completion(movieDetail)
            })
            .store(in: &cancellables)
    }
}
