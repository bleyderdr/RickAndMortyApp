//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 26/03/26.
//

import SwiftUI

@main

struct RickAndMortyAppApp: App {
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navStack) {
                ContentView()
            }.environmentObject(router)
            
        }
    }
}
