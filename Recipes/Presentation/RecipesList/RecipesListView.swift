//
//  RecipesListView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/9/22.
//

import ComposableArchitecture
import SwiftUI

struct RecipesListView: View {
    let store: StoreOf<RecipesListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField(
                            "SearchPlaceholder".localized,
                            text: viewStore.binding(
                                get: \.searchQuery, send: RecipesListFeature.Action.searchQueryChanged
                            )
                        )
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 16)
                    
                    if let errorText = viewStore.errorText {
                        RecipesListErrorView(errorText: errorText)
                    }
                    
                    List {
                        ForEach(viewStore.results) { recipe in
                            NavigationLink(
                                destination: IfLetStore(
                                    self.store.scope(
                                        state: \.selection?.value,
                                        action: RecipesListFeature.Action.recipe
                                    )
                                ) {
                                    RecipeView(store: $0)
                                } else: {
                                    ProgressView()
                                },
                                tag: recipe.id,
                                selection: viewStore.binding(
                                    get: \.selection?.id,
                                    send: RecipesListFeature.Action.recipeTapped(id:)
                                )
                            ) {
                                RecipesListRow(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.background)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8,
                                                      leading: 16,
                                                      bottom: 8,
                                                      trailing: 16))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    
                    Button("APIProviderFooterText".localized) {
                        viewStore.send(.openApiProviderPage)
                    }
                    .foregroundColor(.gray)
                    .padding(.all, 16)
                }
                .background(Color.background)
                .navigationTitle("Search".localized)
            }
            .navigationViewStyle(.stack)
            .accentColor(.orange)
            .onAppear {
                viewStore.send(.reload)
            }
        }
    }
}
