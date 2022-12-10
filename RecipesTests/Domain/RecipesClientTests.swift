//
//  RecipesClientTests.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import Foundation
import XCTest
@testable import Recipes

final class RecipesClientTests: XCTestCase {
    private let networkService = NetworkServiceTypeMock()
    private lazy var recipesClient = RecipesClient(networkService: networkService)
    
    func test_getRecipesFinishedSuccessfully() async throws {
        networkService.response = RecipePreviewResponseMock.mock
        
        do {
            let result = try await recipesClient.getRecipes("")
            XCTAssertEqual(result.results.count, 2)
        } catch {
            XCTFail("Expected recipe array, but failed \(error).")
        }
    }
    
    func test_getRecipesFailedWithError() async throws {
        networkService.requestThrowableError = NetworkError.invalidResponse
        
        do {
            _ = try await recipesClient.getRecipes("")
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            guard let networkError = error as? NetworkError,
                  case NetworkError.invalidResponse = networkError else {
                XCTFail("Expected NetworkError, but failed \(error).")
                return
            }
        }
        
        XCTAssertEqual(networkService.requestCalled, true)
    }
}
