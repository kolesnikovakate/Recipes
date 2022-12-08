//
//  NetworkService.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

final class NetworkService: NetworkServiceType {
    private let config: NetworkConfigurable
    private let session: URLSession
    
    init(config: NetworkConfigurable, session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.config = config
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T {
        guard let request = endpoint.urlRequest(with: config) else {
            throw NetworkError.invalidRequest
        }
        
        let task = try await session.data(for: request)
        guard let response = task.1 as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        let data = task.0
        guard 200..<300 ~= response.statusCode else {
            throw NetworkError.dataLoadingError(statusCode: response.statusCode, data: data)
        }
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
