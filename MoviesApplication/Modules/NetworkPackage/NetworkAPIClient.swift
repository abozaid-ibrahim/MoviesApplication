//
//  NetworkAPIClient.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation

struct NetworkAPIClient: APIClient {
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

        // Add common query parameters for all requests
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "language", value: "en-US")]

        // Check the HTTP method and configure the request accordingly
        var request: URLRequest
        switch endpoint.method {
        case .get:
            // Add query parameters for GET requests
            queryItems += endpoint.parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                throw NetworkError.invalidURL
            }
            request = URLRequest(url: url)
        case .post, .delete:
            // Set up request for POST and DELETE methods
            guard let url = urlComponents.url else {
                throw NetworkError.invalidURL
            }
            request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            if endpoint.method == HTTPMethod.post {
                // Add POST-specific configurations if needed (e.g., HTTP body)
                //                 request.httpBody = ...
            }
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        return try jsonDecoder.decode(T.self, from: data)
    }
}
