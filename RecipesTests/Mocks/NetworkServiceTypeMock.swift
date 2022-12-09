//
//  NetworkServiceMock.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import Foundation
@testable import Recipes

class NetworkServiceTypeMock: NetworkServiceType {
    var requestThrowableError: Error?
    var requestCallsCount = 0
    var requestCalled: Bool {
        return requestCallsCount > 0
    }
    var response: Any?
    
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T {
        requestCallsCount += 1
        
        if let error = requestThrowableError {
            throw error
        }
        
        if let response = response as? T {
            return response
        }
        
        throw TestsError.unimplemented
    }
}
