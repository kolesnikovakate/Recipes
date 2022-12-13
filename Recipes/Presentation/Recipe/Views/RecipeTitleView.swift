//
//  RecipeTitleView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/13/22.
//

import SwiftUI

struct RecipeTitleView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 20) {
            Text(recipe.title)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .largeTitle()
                .padding(20)
            
            Divider()
                .padding(.horizontal, 20)
            
            HStack {
                VStack(spacing: 20) {
                    Image("ic_clock")
                    Text("\(recipe.readyInMinutes) min").subtextTitle()
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 20) {
                    Image("ic_heart")
                    Text("\(recipe.aggregateLikes)").subtextTitle()
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 20) {
                    Image("ic_restaurant")
                    Text("Serves \(recipe.servings)").subtextTitle()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 20)
        }
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

struct RecipeTitleView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTitleView(recipe: MockRecipesClient().getMockRecipe())
    }
}
