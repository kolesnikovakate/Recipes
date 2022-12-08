//
//  NetworkServiceTests.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation
import XCTest
import Combine
@testable import Recipes

class NetworkServiceTests: XCTestCase {
    private let config = NetworkConfigurableMock()
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(config: config, session: session)
    
    private let endpoint = APIEndpoints.getRecipes(with: "")
    private lazy var newsJsonData: Data = {
        let url = Bundle(for: NetworkServiceTests.self).url(forResource: "RecipePreviewList", withExtension: "json")
        guard let resourceUrl = url, let data = try? Data(contentsOf: resourceUrl) else {
            XCTFail("Failed to create data object from string!")
            return Data()
        }
        return data
    }()
    
    override class func setUp() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    func test_requestFinishedSuccessfully() async throws {
        URLProtocolMock.requestHandler = { _ in
            let url = self.endpoint.urlRequest(with: self.config)!.url!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.newsJsonData)
        }
        
        do {
            let result = try await networkService.request(endpoint)
            XCTAssertEqual(result.results.count, 2)
        } catch {
            XCTFail("Expected recipe array, but failed \(error).")
        }
    }
    
    func test_requestFailedWithInternalError() async throws {
        URLProtocolMock.requestHandler = { _ in
            let url = self.endpoint.urlRequest(with: self.config)!.url!
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            guard let networkError = error as? NetworkError,
                  case NetworkError.dataLoadingError(500, _) = networkError else {
                XCTFail("Expected NetworkError, but failed \(error).")
                return
            }
        }
    }
    
    func test_requestFailedWithJsonParsingError() async throws {
        URLProtocolMock.requestHandler = { _ in
            let url = self.endpoint.urlRequest(with: self.config)!.url!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            guard error is DecodingError else {
                XCTFail("Expected DecodingError, but failed \(error).")
                return
            }
        }
    }
}
