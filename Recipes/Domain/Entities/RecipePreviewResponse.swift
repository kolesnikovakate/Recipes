//
//  RecipePreviewResponse.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import Foundation

struct RecipePreviewResponse: Decodable, Equatable {
    let offset: Int
    let number: Int
    let results: [RecipePreview]
    let totalResults: Int
}
