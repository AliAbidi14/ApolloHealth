
//  SplashScreenView.swift
//  ApolloHealth

//  Created by Ali Abidi for the 2024 Congressional App Challenge.


import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color(red: 168/255, green: 1/255, blue: 4/255)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                Image("ApolloCrest")    // Adding application icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .padding()

                Text("Search For Free and Low Cost Healthcare Near You")
                    .font(.custom("ReemKufi-SemiBold", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isActive = false
                }
            }
        }
    }
}
