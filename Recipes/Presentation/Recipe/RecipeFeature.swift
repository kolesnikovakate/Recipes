//
//  RecipeFeature.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/12/22.
//

import ComposableArchitecture
import SwiftUI

struct RecipeFeature: ReducerProtocol {
    enum Tabs: LocalizedStringKey, CaseIterable, Hashable {
        case ingredients = "Ingredients"
        case steps = "Steps"
    }
    
    struct State: Equatable {
        var recipe: Recipe
        var selectedTab = Tabs.ingredients
    }
    
    enum Action: Equatable {
        case select(tab: LocalizedStringKey)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .select(let tabValue):
            if let tab = Tabs(rawValue: tabValue) {
                state.selectedTab = tab
            }
            return .none
        }
    }
}
