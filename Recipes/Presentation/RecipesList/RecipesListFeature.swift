//
//  RecipesListFeature.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import ComposableArchitecture
import UIKit

struct RecipesListFeature: ReducerProtocol {
    private let apiProvider = "https://spoonacular.com/food-api"
    
    struct State: Equatable {
        var selection: Identified<Int, RecipeFeature.State?>?
        
        var results: [RecipePreview] = []
        var searchQuery = ""
        var errorText: String?
    }
    
    enum Action: Equatable {
        case reload
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(TaskResult<RecipePreviewResponse>)
        
        case recipe(RecipeFeature.Action)
        case recipeTapped(id: Int?)
        case openRecipe(TaskResult<Recipe>)
        
        case openApiProviderPage
    }
    
    @Dependency(\.mainQueue) var mainQueue
    let recipesClient: RecipesClientType
    
    init(recipesClient: RecipesClientType) {
        self.recipesClient = recipesClient
    }
    
    private enum SearchRecipesID {}
    private enum LoadRecipeID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
                state.errorText = "ErrorRecipeSearch".localized
                return .none
                
            case let .searchResponse(.success(response)):
                state.results = response.results
                state.errorText = nil
                return .none
                
            case let .recipeTapped(id: .some(id)):
                state.selection = Identified(nil, id: id)
                state.errorText = nil
                return .task {
                    await .openRecipe(TaskResult {
                        try await self.recipesClient.getRecipe(id)
                    })
                }
                .cancellable(id: LoadRecipeID.self)
                
            case .recipeTapped(id: .none):
                state.selection = nil
                state.errorText = nil
                return .cancel(id: LoadRecipeID.self)
                
            case .openRecipe(.failure):
                state.selection = nil
                state.errorText = "ErrorLoadingRecipe".localized
                return .none
                
            case let .openRecipe(.success(recipe)):
                state.selection = Identified(RecipeFeature.State(recipe: recipe), id: recipe.id)
                return .none
                
            case .openApiProviderPage:
                UIApplication.shared.open(URL(string: apiProvider)!)
                return .none
                
            case .recipe:
                return .none
            }
        }
        .ifLet(\State.selection, action: /Action.recipe) {
            EmptyReducer()
                .ifLet(\Identified<Int, RecipeFeature.State?>.value, action: .self) {
                    RecipeFeature()
                }
        }
    }
}
