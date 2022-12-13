//
//  TextModifiers.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/10/22.
//

import SwiftUI

struct TextTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 18).bold())
    }
}

struct SubTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 15))
    }
}

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 22).bold())
    }
}

extension View {
    func textTitle() -> some View {
        self.modifier(TextTitle())
    }
    
    func subtextTitle() -> some View {
        self.modifier(SubTitle())
    }
    
    func largeTitle() -> some View {
        self.modifier(LargeTitle())
    }
}
