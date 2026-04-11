//
//  ScrollPreferenceKey.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 7/04/26.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
