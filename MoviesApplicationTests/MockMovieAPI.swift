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

    func fetchData<T>(for _: MoviesApplication.EndPoint) async throws -> T where T: Decodable {
        guard isSuccess else {
            throw NetworkError.invalidURL
        }

        if endPointPath == EndPointPath.details.rawValue {
            return MovieDetails(title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date()) as! T
        } else {
            return MovieResults(results: [Movie(id: 1, title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())]) as! T
        }
    }

    enum EndPointPath: String {
        case movies
        case details
    }
}
