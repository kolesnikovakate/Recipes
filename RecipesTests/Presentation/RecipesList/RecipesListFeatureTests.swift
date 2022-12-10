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
    let mainQueue = DispatchQueue.test
    
    func testReload() async {
        let response = RecipePreviewResponseMock.mock
        recipesClient.getRecipesReturnValue = response
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        _ = await store.send(.reload)
        await store.receive(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.success(response))) {
            $0.results = response.results
        }
    }
    
    func testSearchQuery() async {
        let response = RecipePreviewResponseMock.mock
        recipesClient.getRecipesReturnValue = response
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        _ = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        await mainQueue.advance(by: 1)
        await store.receive(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.success(response))) {
            $0.results = response.results
        }
    }
    
    func testSearchQueryDuplicates() async {
        let response = RecipePreviewResponseMock.mock
        recipesClient.getRecipesReturnValue = response
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        _ = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        await mainQueue.advance(by: 1)
        await store.receive(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.success(response))) {
            $0.results = response.results
        }
        _ = await store.send(.searchQueryChanged("S"))
    }
    
    func testSearchFailure() async {
        let error = NetworkError.invalidRequest
        recipesClient.getRecipesThrowableError = error
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        _ = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        await mainQueue.advance(by: 1)
        await store.receive(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.failure(error)))
    }
    
    func testSearchQueryCancelsInFlightSearchRequest() async {
        let response = RecipePreviewResponseMock.mock
        recipesClient.getRecipesReturnValue = response
        
        let store = TestStore(
            initialState: RecipesListFeature.State(),
            reducer: RecipesListFeature(recipesClient: recipesClient)
        )
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        let searchQueryChanged = await store.send(.searchQueryChanged("S")) {
            $0.searchQuery = "S"
        }
        await searchQueryChanged.cancel()
        _ = await store.send(.searchQueryChanged("")) {
            $0.searchQuery = ""
        }
        await mainQueue.advance(by: 1)
        await store.receive(.searchQueryChangeDebounced)
        await store.receive(.searchResponse(.success(response))) {
            $0.results = response.results
        }
    }
}
