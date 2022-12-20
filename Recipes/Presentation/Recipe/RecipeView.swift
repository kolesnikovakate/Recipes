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
    
    private let maxImageHeight: CGFloat = 250
    private let minImageHeight: CGFloat = 120
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                ZStack(alignment: .top) {
                    imageHeader(recipe: viewStore.state.recipe)
                    
                    VStack(spacing: 20) {
                        RecipeTitleView(recipe: viewStore.state.recipe)
                        
                        SegmentedControlView(selected: viewStore.binding(
                            get: { $0.selectedTab.rawValue },
                            send: RecipeFeature.Action.select
                        ),
                                             titles: RecipeFeature.Tabs.allCases.map({ $0.rawValue }))
                        .padding(.horizontal, 20)
                        
                        recipeInfoView(state: viewStore.state)
                    }
                    .padding(.top, maxImageHeight - 40)
                }
            }
            .background(Color.background)
        }
    }
    
    private func imageHeader(recipe: Recipe) -> some View {
        GeometryReader { gReader in
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: gReader.frame(in: .global).width,
                   height:
                    self.calculateHeight(minHeight: minImageHeight,
                                         maxHeight: maxImageHeight,
                                         yOffset: gReader.frame(in: .global).origin.y))
            .clipped()
            .offset(y: gReader.frame(in: .global).origin.y < 0 // Is it going up?
                    ? abs(gReader.frame(in: .global).origin.y) // Push it down!
                    : -gReader.frame(in: .global).origin.y) // Push it up!
            Spacer()
        }
    }
    
    private func recipeInfoView(state: RecipeFeature.State) -> some View {
        VStack(spacing: 0) {
            switch state.selectedTab {
            case .ingredients:
                IngredientsView(ingredients: state.recipe.extendedIngredients)
            case .steps:
                Text(state.recipe.summary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
            }
        }
        .animation(.default, value: state.selectedTab)
    }
    
    private func calculateHeight(minHeight: CGFloat, maxHeight: CGFloat, yOffset: CGFloat) -> CGFloat {
        if maxHeight + yOffset < minHeight { // scrolling up
            return minHeight
        }
        return maxHeight + yOffset
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(store: Store(initialState:
                                    RecipeFeature.State(recipe: MockRecipesClient().getMockRecipe()), reducer: RecipeFeature()))
    }
}
