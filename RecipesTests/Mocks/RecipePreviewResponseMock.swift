//
//  RecipePreviewResponseMock.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/10/22.
//

import Foundation
@testable import Recipes

// swiftlint:disable all
class RecipePreviewResponseMock {
    static var mock: RecipePreviewResponse = {
        let url = Bundle(for: RecipePreviewResponseMock.self).url(forResource: "RecipePreviewList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let response = try! JSONDecoder().decode(RecipePreviewResponse.self, from: data)
        return response
    }()
}

class RecipeMock {
    static var mock: Recipe = {
        let url = Bundle(for: RecipePreviewResponseMock.self).url(forResource: "Recipe", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let response = try! JSONDecoder().decode(Recipe.self, from: data)
        return response
    }()
}
// swiftlint:enable all
