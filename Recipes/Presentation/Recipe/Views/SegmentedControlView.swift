//
//  SegmentedControlView.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/12/22.
//

import SwiftUI

struct SegmentedControlView: View {
    @Binding private var selected: LocalizedStringKey
    private let titles: [LocalizedStringKey]
    
    init(selected: Binding<LocalizedStringKey>, titles: [LocalizedStringKey]) {
        self._selected = selected
        self.titles = titles
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                Button(action: {
                    selected = titles[index]
                }) {
                    Text(titles[index])
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(selected == titles[index] ? .orange : .clear)
                .cornerRadius(16)
                .foregroundColor(selected == titles[index] ? .white : .black)
                .padding(8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(.white)
        .cornerRadius(26)
    }
}

struct SegmentedControlView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.gray)
            SegmentedControlView(selected: .constant("qwerty"), titles: ["qwerty", "sdfghjkl"])
                .padding(20)
        }
    }
}
