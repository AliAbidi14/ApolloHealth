//
//  LanguageSelectionView.swift
//  ApolloHealth
//
//  Created by Ali Abidi on 8/20/26.
//
import SwiftUI

enum AppLanguage: String {
    case english = "en"
    case spanish = "es"
    case hmong = "hmn"
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: AppLanguage?
    
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

                Text("Choose Your Language")
                    .font(.custom("ReemKufi-SemiBold", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)

                VStack(spacing: 14) {
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

                Spacer()
            }
        }
    }

    private func languageButton(
        title: String,
        language: AppLanguage
    ) -> some View {
        Button {
            selectedLanguage = language
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 168/255, green: 1/255, blue: 4/255))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}
