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
        var selection: Identified<Int, RecipeFeature.State?>?
        
        var results: [RecipePreview] = []
        var searchQuery = ""
    }
    
    enum Action: Equatable {
        case reload
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(TaskResult<RecipePreviewResponse>)
        
        case recipe(RecipeFeature.Action)
        case searchResultTapped(id: Int?)
        case openRecipe(RecipeFeature.State)
    }
    
    @Dependency(\.mainQueue) var mainQueue
    let recipesClient: RecipesClientType
    
    init(recipesClient: RecipesClientType) {
        self.recipesClient = recipesClient
    }
    
    private enum SearchRecipesID {}
    private enum LoadRecipeID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .reload:
            return Effect(value: .searchQueryChangeDebounced)
            
        case let .searchQueryChanged(query):
            guard state.searchQuery != query else {
                return .none
            }
            state.searchQuery = query
            return Effect(value: .searchQueryChangeDebounced)
                .debounce(id: SearchRecipesID.self, for: 1, scheduler: mainQueue)
            
        case .searchQueryChangeDebounced:
            return .task { [query = state.searchQuery] in
                await .searchResponse(TaskResult {
                    try await self.recipesClient.getRecipes(query)
                    
                })
            }
            .cancellable(id: SearchRecipesID.self)
            
        case .searchResponse(.failure):
            state.results = []
            return .none
            
        case let .searchResponse(.success(response)):
            state.results = response.results
            return .none
            
        case let .searchResultTapped(id: .some(id)):
            state.selection = Identified(nil, id: id)
            return .task {
                try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
                return .openRecipe(Recipe(id: 1, title: "title", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg", servings: 2, readyInMinutes: 20, summary: "summary", extendedIngredients: []))
            }
            .cancellable(id: LoadRecipeID.self, cancelInFlight: true)
            
        case .searchResultTapped(id: .none):
            state.selection = nil
            return .cancel(id: LoadRecipeID.self)
            
        case let .openRecipe(recipe):
            state.selection = Identified(recipe, id: recipe.id)
            return .none
            
        case .recipe:
            return .none
        }
    }
}
