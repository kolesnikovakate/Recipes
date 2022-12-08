//
//  Recipe.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

struct Recipe: Decodable {
    let id: Int
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let summary: String
    let extendedIngredients: [Ingredient]
}
