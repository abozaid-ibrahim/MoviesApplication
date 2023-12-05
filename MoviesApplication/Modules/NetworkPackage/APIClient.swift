//
//  APIClient.swift
//  MoviesApplication
//
//  Created by abuzeid on 05.12.23.
//

import Foundation

protocol APIClient {
    var baseUrl: String { get }

    func fetchData<T: Decodable>(for endpoint: EndPoint) async throws -> T
}
