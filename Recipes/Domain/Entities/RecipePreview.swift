//
//  RecipePreview.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

struct RecipePreview: Decodable, Equatable, Identifiable {
    let id: Int
    let title: String
    let image: String
}
