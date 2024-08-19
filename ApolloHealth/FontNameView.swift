//
//  FontNameView.swift
//  ApolloHealth
//
//  Created by Ali Abidi on 8/2/24.
//

import SwiftUI

struct FontListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Available Fonts:")
                .font(.headline)
                .padding(.bottom, 10)
            
            ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
                VStack(alignment: .leading) {
                    Text(family)
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    ForEach(UIFont.fontNames(forFamilyName: family).sorted(), id: \.self) { fontName in
                        Text(fontName)
                            .font(.system(size: 14))
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .padding()
        .onAppear {
            print("Available fonts:")
            for family in UIFont.familyNames {
                print("Family: \(family)")
                for fontName in UIFont.fontNames(forFamilyName: family) {
                    print("  Font: \(fontName)")
                }
            }
        }
    }
}


