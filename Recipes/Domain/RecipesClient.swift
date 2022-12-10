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
//        return RecipePreviewResponse(offset: 0, number: 5, results: [RecipePreview(id: 1, title: "Resep Ayam Kuah Santan Pedas Lezat", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg"),
//                                                                     RecipePreview(id: 1, title: "Resep Ayam Kuah Santan Pedas Lezat", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg")],
//                                     totalResults: 2)
        return try await networkService.request(APIEndpoints.getRecipes(with: query))
    }
}
