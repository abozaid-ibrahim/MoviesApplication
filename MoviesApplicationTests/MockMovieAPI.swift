//
//  MockMovieAPI.swift
//  MoviesApplicationTests
//
//  Created by abuzeid on 04.12.23.
//

import Foundation
@testable import MoviesApplication
import Combine
struct MockMovieAPI: APIClient {
    var baseUrl: String = ""
    let isSuccess: Bool
    let endPointPath: String

    func fetchData<T>(for _: MoviesApplication.EndPoint) -> AnyPublisher<T, Error> where T: Decodable {
        guard isSuccess else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        if endPointPath == "details" {
            let details = MovieDetails(title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())
            return Just(details as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            let results = MovieResults(results: [Movie(id: 1, title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())])
            return Just(results as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
