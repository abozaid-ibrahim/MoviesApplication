//
//  MovieAPIClient.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

struct MovieAPIClient: APIClient {
    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    let baseUrl = "https://api.themoviedb.org/3/"

    private var jsonDecoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    func fetchData<T: Decodable>(for endpoint: EndPoint) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseUrl)\(endpoint.path)") else {
            throw NetworkError.invalidURL
        }
        // Add common query parameter for all requests
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "language", value: "en-US")]

        if endpoint.method == .get {
            // Add query parameters for GET requests
            queryItems += endpoint.parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            urlComponents.queryItems = queryItems
        } else {
            throw NetworkError.unsupportedMethod
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try jsonDecoder.decode(T.self, from: data)
    }
}
