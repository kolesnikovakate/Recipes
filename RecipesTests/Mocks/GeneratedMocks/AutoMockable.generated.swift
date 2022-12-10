// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
@testable import Recipes
















class RecipesClientTypeMock: RecipesClientType {

    //MARK: - getRecipes

    var getRecipesThrowableError: Error?
    var getRecipesCallsCount = 0
    var getRecipesCalled: Bool {
        return getRecipesCallsCount > 0
    }
    var getRecipesReceivedQuery: String?
    var getRecipesReceivedInvocations: [String] = []
    var getRecipesReturnValue: RecipePreviewResponse!
    var getRecipesClosure: ((String) async throws -> RecipePreviewResponse)?

    func getRecipes(_ query: String) async throws -> RecipePreviewResponse {
        if let error = getRecipesThrowableError {
            throw error
        }
        getRecipesCallsCount += 1
        getRecipesReceivedQuery = query
        getRecipesReceivedInvocations.append(query)
        if let getRecipesClosure = getRecipesClosure {
            return try await getRecipesClosure(query)
        } else {
            return getRecipesReturnValue
        }
    }

}

// swiftlint:enable all
