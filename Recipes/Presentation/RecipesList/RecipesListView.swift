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
                            "Pasta, Bruschetta, ...",
                            text: viewStore.binding(
                                get: \.searchQuery, send: RecipesListFeature.Action.searchQueryChanged
                            )
                        )
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 16)
                    
                    List {
                        ForEach(viewStore.results) { recipe in
                            Button(action: { viewStore.send(.searchResultTapped(recipe)) }) {
                                RecipesListRow(recipe: recipe)
                            }
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
                    
                    Button("Recipes API provided by spoonacular") {
                        UIApplication.shared.open(URL(string: "https://spoonacular.com/food-api")!)
                    }
                    .foregroundColor(.gray)
                    .padding(.all, 16)
                }
                .background(Color.background)
                .navigationTitle("Search")
            }
            .navigationViewStyle(.stack)
            .onAppear {
                viewStore.send(.reload)
            }
        }
    }
}
