//
//  RecipesApp.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import ComposableArchitecture
import SwiftUI

@main
struct RecipesApp: App {
    let container = AppDIContainer()
    
    var body: some Scene {
        WindowGroup {
            RecipesListView(store: Store(initialState: RecipesListFeature.State(),
                                         reducer: RecipesListFeature(recipesClient: container.recipesClient)))
        }
    }
}
