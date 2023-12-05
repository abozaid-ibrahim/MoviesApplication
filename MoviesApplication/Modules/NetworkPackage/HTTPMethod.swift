//
//  HTTPMethod.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation

struct EndPoint {
    let path: String
    let method: HTTPMethod
    let parameters: [String: Any]
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case unsupportedMethod
}
