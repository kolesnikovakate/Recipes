//
//  RecipeFeature.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/12/22.
//

import ComposableArchitecture
import Foundation

struct RecipeFeature: ReducerProtocol {
    typealias State = Recipe
    
    enum Action: Equatable { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}
