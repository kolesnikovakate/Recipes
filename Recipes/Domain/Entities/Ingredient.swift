//
//  Ingredient.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

struct Ingredient: Decodable, Identifiable {
    let id: Int
    let original: String
    let originalName: String
    let unit: String
    let amount: Double
}
