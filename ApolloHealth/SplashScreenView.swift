
//  SplashScreenView.swift
//  ApolloHealth

//  Created by Ali Abidi for the 2024 Congressional App Challenge.


import SwiftUI

struct SplashScreenView: View {

    @Binding var isActive: Bool
    @Binding var selectedLanguage: AppLanguage?

    @State private var showLanguageOptions = false

    var body: some View {

        ZStack {

            Color(red: 168/255, green: 1/255, blue: 4/255)
                .edgesIgnoringSafeArea(.all)

            VStack {

                Image("ApolloCrest")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .padding(.top, 110)

                ZStack {

                    if !showLanguageOptions {

                        Text("Search For Free and Low Cost Healthcare Near You")
                            .font(.custom("ReemKufi-SemiBold", size: 24))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .transition(.opacity)

                    } else {

                        VStack(spacing: 14) {

                            Text("Language • Idioma • Lus")
                                .font(.custom("ReemKufi-SemiBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 12)

                            languageButton(
                                title: "English",
                                language: .english
                            )

                            languageButton(
                                title: "Español",
                                language: .spanish
                            )

                            languageButton(
                                title: "Hmoob",
                                language: .hmong
                            )
                        }
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                    }
                }

                Spacer()
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

                withAnimation(.easeInOut(duration: 0.6)) {
                    showLanguageOptions = true
                }
            }
        }
    }

    private func languageButton(
        title: String,
        language: AppLanguage
    ) -> some View {

        Button {

            selectedLanguage = language
            isActive = false

        } label: {

            Text(title)
                .font(.custom("ReemKufi-SemiBold", size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            Color(
                                red: 168/255,
                                green: 1/255,
                                blue: 4/255
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 4)
                )
        }
    }
}
