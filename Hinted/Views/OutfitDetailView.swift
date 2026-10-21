//
//  OutfitDetailView.swift
//  Hinted
//
//  Created by esther ricardo on 10/20/26.
//

import SwiftUI

struct OutfitDetailView: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                Text("Your Outfit")
                    .font(HintedFonts.adLib(30))
                
                // Outfit Preview
                HStack(spacing: 10) {
                    
                    Image("outfitTop")
                        .resizable()
                        .scaledToFit()
                    
                    Image("outfitBag")
                        .resizable()
                        .scaledToFit()

                    Image("outfitShoes")
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 200)
                .padding()
                .background(HintedColors.lightYellow)
                .clipShape(
                        RoundedRectangle(cornerRadius: 20))

                Text("Your outfit details will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding(20)
            }
            .background(HintedColors.cream)
            .navigationTitle("Outfit Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    #Preview {
        NavigationStack {
            OutfitDetailView()
        }
    }
