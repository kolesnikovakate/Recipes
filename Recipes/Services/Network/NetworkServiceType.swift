//
//  NetworkServiceType.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

protocol NetworkServiceType: AnyObject {
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.dataLoadingError(let lhsStatusCode, _), .dataLoadingError(let rhsStatusCode, _)): return lhsStatusCode == rhsStatusCode
        default: return false
        }
    }
}
