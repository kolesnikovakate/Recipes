//
//  AppDIContainer.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import Foundation

protocol AppDependencyProvider {
    var networkService: NetworkServiceType { get }
    var recipesClient: RecipesClientType { get }
}

final class AppDIContainer: AppDependencyProvider {
    private let apiUrl = "https://api.spoonacular.com/"
    private let apiKey = "dc8c863524f24ef9936e7c2a93f8bd85"
    
    lazy var networkService: NetworkServiceType = {
        let config = NetworkConfig(baseURL: URL(string: apiUrl)!,
                                   headers: ["apiKey": apiKey])
        return NetworkService(config: config)
    }()
    
    lazy var recipesClient: RecipesClientType = MockRecipesClient()
    // RecipesClient(networkService: networkService)
}
