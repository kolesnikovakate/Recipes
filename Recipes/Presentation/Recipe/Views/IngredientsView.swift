//
//  IngredientsView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/13/22.
//

import SwiftUI

struct IngredientsView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(ingredients) { ingredient in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(.orange)
                        .frame(width: 12, height: 12)
                        .padding(.vertical, 6)
                    Text(ingredient.original)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                
                if ingredient.id != ingredients.last?.id {
                    Divider()
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding(20)
        .background(.white)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.gray)
            IngredientsView(ingredients: MockRecipesClient().getMockRecipe().extendedIngredients)
        }
    }
}
