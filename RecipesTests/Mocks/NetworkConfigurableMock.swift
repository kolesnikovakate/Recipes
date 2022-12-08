//
//  NetworkConfigurableMock.swift
//  RecipesTests
//
//  Created by Ekaterina Kolesnikova on 12/8/22.
//

import Foundation
@testable import Recipes

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
