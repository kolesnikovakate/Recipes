//
//  RecipesListRow.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/10/22.
//

import SwiftUI

struct RecipesListRow: View {
    let recipe: RecipePreview
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(height: 200, alignment: .center)
                    .cornerRadius(16)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(height: 200)
                    .cornerRadius(16)
            }
            
            Text(recipe.title).lineLimit(3).textTitle()
        }
    }
}

struct RecipesListRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListRow(recipe: RecipePreview(id: 1, title: "Resep Ayam Kuah Santan Pedas Lezat", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg"))
    }
}
