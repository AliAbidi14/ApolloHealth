
//  ApolloHealthApp.swift
//  ApolloHealth
//  Created by Ali Abidi for the 2024 Congressional App Challenge.


import SwiftUI

@main
struct MyApp: App {
    @State private var isSplashActive: Bool = true

    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashScreenView(isActive: $isSplashActive)
            } else {
                InputScreenView()
            }
        }
    }
}
