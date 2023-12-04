//
//  MockMovieAPI.swift
//  MoviesApplicationTests
//
//  Created by abuzeid on 04.12.23.
//

import Combine
import Foundation
@testable import MoviesApplication
struct MockMovieAPI: APIClient {
    var baseUrl: String = ""
    let isSuccess: Bool
    let endPointPath: String

    func fetchData<T>(for _: MoviesApplication.EndPoint) -> AnyPublisher<T, Error> where T: Decodable {
        guard isSuccess else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        if endPointPath == EndPointPath.details.rawValue {
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

    enum EndPointPath: String {
        case movies
        case details
    }
}
