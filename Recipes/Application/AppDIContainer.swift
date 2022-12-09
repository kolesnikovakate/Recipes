//
//  AppDIContainer.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import Foundation

protocol AppDependencyProvider {
    var networkService: NetworkServiceType { get }
    var recipesClient: RecipesClient { get }
}

final class AppDIContainer: AppDependencyProvider {
    private let apiUrl = "https://api.spoonacular.com/"
    private let apiKey = "593ba12fa78343e0b42bc41814f313a3"
    
    lazy var networkService: NetworkServiceType = {
        let config = NetworkConfig(baseURL: URL(string: apiUrl)!,
                                   headers: ["apiKey": apiKey])
        return NetworkService(config: config)
    }()
    
    lazy var recipesClient: RecipesClient = RecipesClient(networkService: networkService)
}
