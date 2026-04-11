//
//  AnimatableFontModifier.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 7/04/26.
//

import SwiftUI

struct AnimatableFontModifier: AnimatableModifier {
    
    var size: Double
    var weight: Font.Weight = .regular
    var desing: Font.Design = .default
    
    var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: desing))
    }
}

extension View {
    func animatableFont(size: Double, weight: Font.Weight, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight, desing: design))
        
    }
}


