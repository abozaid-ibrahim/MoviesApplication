//
//  HTTPMethod.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Combine
import Foundation
import Combine


protocol APIClient {
    var baseUrl: String { get }
    func fetchData<T: Decodable>(for endpoint: EndPoint) -> AnyPublisher<T, Error>
}

struct EndPoint {
    let path: String
    let method: HTTPMethod
    let parameters: [String: Any]
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case unsupportedMethod
}