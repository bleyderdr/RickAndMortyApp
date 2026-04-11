//
//  Router.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 31/03/26.
//

import SwiftUI
import Combine

protocol RouterDelegate {
    
    associatedtype Route = Path
    //Activar una nueva vista
    func pushView(_ newView : Route)
    //ir a la pantalla de inicio o Home
    func popToRoute()
    //ir a la pantalla anterioe
    func pop()
    //navegar a opciones o pantallas en medio
    func popUnit(_ targeRoute : Route)
}

extension Router {
    enum Paths: Equatable, CaseIterable {
        static var allCases: [Router.Paths] = [.homePage]
        case homePage
        case custom(view: AnyView)
     }
    
    enum Routes {
        static let routes: [Paths: AnyView] = [
            .homePage: AnyView(HomePage(viewModel: HomePageViewModel())),
        ]
    }
    static func getRoute(for path: Paths) -> AnyView {
        switch path {
            
        case .homePage:
            return AnyView(HomePage(viewModel: HomePageViewModel()))
        case .custom(let view):
            return view
        }
    }
}

class Router : ObservableObject, RouterDelegate {
    
    @Environment(\.presentationMode) var presentationMode
    @Published var navStack: [Paths] = []
    
    func pushView(_ newView: Paths) {
        navStack.append(newView)
    }
    
    func popToRoute() {
        navStack.removeAll()
    }
    
    func pop() {
        if !navStack.isEmpty{
            navStack.removeLast()
        }
    }
    
    func popUnit(_ targeRoute: Paths) {
        if !navStack.isEmpty{
            navStack.removeLast()
        }
    }
}

extension View {
    func pushPath() -> some View {
        self.navigationDestination(for: Router.Paths.self) { path in
            Router.getRoute(for: path)
        }
    }
}


extension Router.Paths: Hashable {
    
    static func == (lhs: Router.Paths, rhs: Router.Paths) -> Bool {
        switch(lhs, rhs) {
        case (.homePage, .homePage):
            return true
        case (.custom, .custom):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .homePage:
            hasher.combine("homePage")
        case .custom(_):
            hasher.combine("custom")
        }
    }
}
