//
//  RecipesClient.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import ComposableArchitecture
import Foundation

// sourcery: AutoMockable
protocol RecipesClientType: AnyObject {
    func getRecipes(_ query: String) async throws -> RecipePreviewResponse
    func getRecipe(_ id: Int) async throws -> Recipe
}
final class RecipesClient: RecipesClientType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getRecipes(_ query: String) async throws -> RecipePreviewResponse {
        return try await networkService.request(APIEndpoints.getRecipes(with: query))
    }
    
    func getRecipe(_ id: Int) async throws -> Recipe {
        return try await networkService.request(APIEndpoints.getRecipe(by: id))
    }
}

final class MockRecipesClient: RecipesClientType {
    func getMockRecipes() -> RecipePreviewResponse {
        RecipePreviewResponse(offset: 0, number: 5, results: [RecipePreview(id: 1, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs", image: "https://spoonacular.com/recipeImages/716429-556x370.jpg"),
                                                              RecipePreview(id: 2, title: "Lasagne bolognese", image: "https://www.kwestiasmaku.com/sites/v123.kwestiasmaku.com/files/lasagne_bolognese_01.jpg")],
                              totalResults: 2)
    }
    
    func getRecipes(_ query: String) async throws -> RecipePreviewResponse {
        getMockRecipes()
    }
    
    func getMockRecipe(_ id: Int = 1) -> Recipe {
        Recipe(id: id, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
               image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
               servings: 2,
               readyInMinutes: 45,
               // swiftlint:disable:next line_length
               summary: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs might be a good recipe to expand your main course repertoire. One portion of this dish contains approximately <b>19g of protein </b>,  <b>20g of fat </b>, and a total of  <b>584 calories </b>. For  <b>$1.63 per serving </b>, this recipe  <b>covers 23% </b> of your daily requirements of vitamins and minerals. This recipe serves 2. It is brought to you by fullbellysisters.blogspot.com. 209 people were glad they tried this recipe. A mixture of scallions, salt and pepper, white wine, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes approximately  <b>45 minutes </b>. All things considered, we decided this recipe  <b>deserves a spoonacular score of 83% </b>. This score is awesome. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/cauliflower-gratin-with-garlic-breadcrumbs-318375\">Cauliflower Gratin with Garlic Breadcrumbs</a>, < href=\"https://spoonacular.com/recipes/pasta-with-cauliflower-sausage-breadcrumbs-30437\">Pasta With Cauliflower, Sausage, & Breadcrumbs</a>, and <a href=\"https://spoonacular.com/recipes/pasta-with-roasted-cauliflower-parsley-and-breadcrumbs-30738\">Pasta With Roasted Cauliflower, Parsley, And Breadcrumbs</a>.",
               aggregateLikes: 345,
               extendedIngredients: [
                Ingredient(id: 1, original: "1 tbsp butter", originalName: "butter", unit: "tbsp", amount: 1.0),
                Ingredient(id: 2, original: "about 2 cups frozen cauliflower florets, thawed, cut into bite-sized pieces", originalName: "about frozen cauliflower florets, thawed, cut into bite-sized pieces", unit: "cups", amount: 2.0),
                Ingredient(id: 3, original: "2 tbsp grated cheese (I used romano)", originalName: "grated cheese (I used romano)", unit: "tbsp", amount: 2.0),
                Ingredient(id: 4, original: "1-2 tbsp extra virgin olive oil", originalName: "extra virgin olive oil", unit: "tbsp", amount: 1.0)
               ])
    }
    
    func getRecipe(_ id: Int) async throws -> Recipe {
        getMockRecipe(id)
    }
}
