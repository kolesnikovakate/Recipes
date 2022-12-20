//
//  RecipesListErrorView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/20/22.
//

import SwiftUI

struct RecipesListErrorView: View {
    let errorText: String
    
    var body: some View {
        Text(errorText)
            .subtextTitle()
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color.orangeAccent.opacity(0.2))
    }
}

struct RecipesListErrorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListErrorView(errorText: "Error")
    }
}
