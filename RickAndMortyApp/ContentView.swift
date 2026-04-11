//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 26/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = NavigationBarModel()
    
    var body: some View {
        HomePage(viewModel: HomePageViewModel())
            .environmentObject(model)
    }
}

#Preview {
    ContentView()
}
