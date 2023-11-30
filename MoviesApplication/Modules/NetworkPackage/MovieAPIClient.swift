//
//  APIClient.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import Combine
import Combine


struct MovieAPIClient: APIClient {
    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    let baseUrl = "https://api.themoviedb.org/3/"
    private var jsonDecoder: JSONDecoder = {
        // Create a custom date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    func fetchData<T: Decodable>(for endpoint: EndPoint) -> AnyPublisher<T, Error> {
        guard var urlComponents = URLComponents(string: "\(baseUrl)\(endpoint.path)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
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
            return Fail(error: NetworkError.unsupportedMethod).eraseToAnyPublisher()
        }

        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
