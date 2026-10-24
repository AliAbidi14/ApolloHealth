
//  ApolloHealthApp.swift
//  ApolloHealth
//  Created by Ali Abidi for the 2024 Congressional App Challenge.


import SwiftUI

@main
struct MyApp: App {

    @State private var isSplashActive = true
    @State private var selectedLanguage: AppLanguage? = nil

    var body: some Scene {
        WindowGroup {

            if isSplashActive {

                SplashScreenView(
                    isActive: $isSplashActive,
                    selectedLanguage: $selectedLanguage
                )

            } else if let selectedLanguage {

                InputScreenView(
                    language: selectedLanguage
                )
            }
        }
    }
}
