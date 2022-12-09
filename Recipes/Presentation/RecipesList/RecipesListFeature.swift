//
//  RecipesListFeature.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import ComposableArchitecture
import Foundation

struct RecipesListFeature: ReducerProtocol {
    struct State: Equatable {
        var results: [RecipePreview] = []
        var searchQuery = ""
    }
    
    enum Action: Equatable {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(TaskResult<RecipePreviewResponse>)
        case searchResultTapped(RecipePreview)
    }
    
    let recipesClient: RecipesClientType
    
    init(recipesClient: RecipesClientType) {
        self.recipesClient = recipesClient
    }
    
    private enum SearchRecipeID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case let .searchQueryChanged(query):
            state.searchQuery = query
            
            guard !query.isEmpty else {
                state.results = []
                return .cancel(id: SearchRecipeID.self)
            }
            return .none
            
        case .searchQueryChangeDebounced:
            guard !state.searchQuery.isEmpty else {
                return .none
            }
            return .task { [query = state.searchQuery] in
                await .searchResponse(TaskResult {
                    try await self.recipesClient.getRecipes(query)
                    
                })
            }
            .cancellable(id: SearchRecipeID.self)
            
        case .searchResponse(.failure):
            state.results = []
            return .none
            
        case let .searchResponse(.success(response)):
            state.results = response.results
            return .none
            
        case let .searchResultTapped(recipe):
            // TODO: - open Recipe view
            return .none
        }
    }
}
