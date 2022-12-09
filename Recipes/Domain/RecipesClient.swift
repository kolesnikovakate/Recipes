//
//  RecipesClient.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import ComposableArchitecture
import Foundation

// sourcery: AutoMockable
protocol RecipesClientType: AnyObject {
    func getRecipes(_ query: String) async throws -> RecipePreviewResponse
}
final class RecipesClient: RecipesClientType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getRecipes(_ query: String) async throws -> RecipePreviewResponse {
        return try await networkService.request(APIEndpoints.getRecipes(with: query))
    }
}
