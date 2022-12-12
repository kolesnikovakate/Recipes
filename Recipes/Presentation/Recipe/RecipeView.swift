//
//  RecipeView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/12/22.
//

import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    let store: StoreOf<RecipeFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(viewStore.title)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(store: Store(initialState: Recipe(id: 1, title: "title", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg",
                                                     servings: 2, readyInMinutes: 20, summary: "summary", extendedIngredients: []), reducer: RecipeFeature()))
    }
}
