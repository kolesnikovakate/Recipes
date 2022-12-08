//
//  RecipePreview.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation

struct RecipePreviewList: Decodable {
    let offset: Int
    let number: Int
    let results: [RecipePreview]
    let totalResults: Int
}

struct RecipePreview: Decodable {
    let id: Int
    let title: String
    let image: String
}
