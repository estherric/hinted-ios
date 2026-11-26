//
//  OutfitItemCardView.swift
//  Hinted
//
//  Created by esther ricardo on 11/24/26.
//

import SwiftUI

// MARK: - Outfit Item Card
// Reusable card to display clothing in a recommended outfit

struct OutfitItemCardView: View {
    
    // clothing item retrieved from SwiftData
    let item: ClothingItem
    
    // label that describes the clothing category
    let category: String
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            // MARK: - Clothing Image
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(HintedColors.gray)
                
                // case 1: user upladed a clothing img
                if let imageData = item.imageData,
                   let image = UIImage(data: imageData) {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                    
                // case 2: clothing imported from our API: Channel3
                } else if let imageURL = item.imageURL,
                          let url = URL(string: imageURL) {
                    
                    AsyncImage(url: url) { phase in
                        switch phase {
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                            
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundStyle(HintedColors.purple)
                            
                        default:
                            ProgressView()
                        }
                    }
                
                // case 3: no photo or img available
                } else {
                    
                    Image(systemName: item.imageName)
                        .font(.system(size: 30))
                        .foregroundStyle(HintedColors.purple)
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // MARK: - Clothing Information
            VStack(alignment: .leading, spacing: 6) {
                
                Text(category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(HintedColors.cream)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
