//
//  RecipeFeatureTests.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/20/22.
//

import ComposableArchitecture
import XCTest

@testable import Recipes

@MainActor
final class RecipeFeatureTests: XCTestCase {
    func testSelectTab() async {
        let recipe = RecipeMock.mock
        let store = TestStore(
            initialState: RecipeFeature.State(recipe: recipe),
            reducer: RecipeFeature()
        )
        
        _ = await store.send(.select(tab: RecipeFeature.Tabs.steps.rawValue)) {
            $0.selectedTab = RecipeFeature.Tabs.steps
        }
        _ = await store.send(.select(tab: RecipeFeature.Tabs.steps.rawValue))
        _ = await store.send(.select(tab: RecipeFeature.Tabs.ingredients.rawValue)) {
            $0.selectedTab = RecipeFeature.Tabs.ingredients
        }
    }
}
