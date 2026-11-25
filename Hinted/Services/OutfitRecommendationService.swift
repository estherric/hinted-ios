//
//  OutfitRecommendationService.swift
//  Hinted
//
//  Created by esther ricardo on 11/24/26.
//

import Foundation

// MARK: - Recommended Outfit

// represents the clothing pieces selected for an outfit
struct RecommendedOutfit {
    
    let top: ClothingItem
    let bottom: ClothingItem
    let shoes: ClothingItem
    
    // outerwear is optional bc some outfits does not need it
    let outerwear: ClothingItem?
}

// MARK: - Outfit Recommendation Service

struct OutfitRecommendationService {
    
    // generates an outfit using items from user's closet
    // returns nil -> closet doesnt contain a top, bottom, and pair of shoes
    
    func generateOutfit(
        from clothingItems: [ClothingItem],
        vibe: String
    ) -> RecommendedOutfit? {
        
        // separate clothes into categories
        let tops = clothingItems.filter {
            $0.category == "Tops"
        }
        
        let bottoms = clothingItems.filter {
            $0.category == "Bottoms"
        }
        
        let shoes = clothingItems.filter {
            $0.category == "Shoes"
        }
        
        let outerwear = clothingItems.filter {
            $0.category == "Outerwear"
        }

        // make sure we can create a complete outfit
        guard !tops.isEmpty, !bottoms.isEmpty, !shoes.isEmpty
        
        else {
            return nil
        }
        
        // select clothing pieces
        // random selection for first working prototype
        guard let selectedTop = tops.randomElement(),
              let selectedBottom = bottoms.randomElement(),
              let selectedShoes = shoes.randomElement()
        
        else {
            return nil
        }
        
        // include outerwear for a 'Cozy' vibe
        let selectedOuterwear: ClothingItem?
        
        if vibe == "Cozy" {
            selectedOuterwear = outerwear.randomElement()
        } else {
            selectedOuterwear = nil
        }
        
        // return the recommended outfit
        return RecommendedOutfit(
            top: selectedTop,
            bottom: selectedBottom,
            shoes: selectedShoes,
            outerwear: selectedOuterwear
        )
    }
}
