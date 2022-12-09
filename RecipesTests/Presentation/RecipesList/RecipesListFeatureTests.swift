//
//  RecipesListFeatureTests.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/10/22.
//

import ComposableArchitecture
import XCTest

@testable import Recipes

@MainActor
final class RecipesListFeatureTests: XCTestCase {
    let recipesClient = RecipesClientTypeMock()
    
    func testSearchAndClearQuery() async {
        let response = RecipePreviewResponseMock.mock
        recipesClient.getRecipesReturnValue = response
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        
        _ = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        _ = await store.send(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.success(response))) {
            $0.results = response.results
        }
        _ = await store.send(.searchQueryChanged("")) {
            $0.results = []
            $0.searchQuery = ""
        }
    }
    
    func testSearchFailure() async {
        let error = NetworkError.invalidRequest
        recipesClient.getRecipesThrowableError = error
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        
        _ = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        _ = await store.send(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.failure(error)))
    }
    
    func testClearQueryCancelsInFlightSearchRequest() async {
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        
        let searchQueryChanged = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        await searchQueryChanged.cancel()
        _ = await store.send(.searchQueryChanged("")) {
            $0.searchQuery = ""
        }
    }
}
