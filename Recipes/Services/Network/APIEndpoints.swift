//
//  APIEndpoints.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

struct APIEndpoints {
    static func getRecipes(with query: String) -> Endpoint<RecipePreviewResponse> {
        Endpoint(path: "/recipes/complexSearch",
                 method: .get,
                 queryParameters: ["query": query,
                                   "sort": "popularity",
                                   "sortDirection": "asc"])
    }
    
    static func getRecipe(by id: Int) -> Endpoint<Recipe> {
        Endpoint(path: "/recipes/\(id)/information",
                 method: .get,
                 queryParameters: ["includeNutrition": false])
    }
}
