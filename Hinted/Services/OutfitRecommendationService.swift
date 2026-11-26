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
    
    // MARK: - Generate Outfit
    
    // generates an outfit using items from user's closet
    // returns nil -> closet doesnt contain a top, bottom, and pair of shoes
    
    func generateOutfit(
        from clothingItems: [ClothingItem],
        vibe: String,
        temperature: Double? = nil,
        weatherCode: Int? = nil
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
        guard let selectedTop = selectItem(from: tops, vibe: vibe),
              let selectedBottom = selectItem(from: bottoms, vibe: vibe),
              let selectedShoes = selectItem(from: shoes, vibe: vibe)
                
                else {
            return nil
        }
        
        // include outerwear for a 'Cozy' and 'Streetwear' vibe
        let selectedOuterwear: ClothingItem?
        
        if vibe == "Cozy" || vibe == "Streetwear" {
            selectedOuterwear = selectItem(from: outerwear, vibe: vibe)
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
    
    // MARK: - Select Clothing
    
    // choose among the clothing items with the highest vibe score
    private func selectItem(
        from items: [ClothingItem],
        vibe: String
    ) -> ClothingItem? {
        
        guard !items.isEmpty else { return nil }
        
        // calculate the compatibility score for each item
        let scoredItems = items.map { item in
            (item: item, score: vibeScore(for: item, vibe: vibe))
        }
        
        // find the highest compatility score
        let highestScore = scoredItems.map { $0.score }.max() ?? 0
        
        // keep all items tied for the highest score
        let bestMatches = scoredItems
            .filter { $0.score == highestScore }
            .map { $0.item }
        
        // randomize only among equaly good matches
        return bestMatches.randomElement()
    }
    
    // MARK: - Vibe Compatibility Score
    
    // assigns a score based on the clothing item's details
    private func vibeScore(
        for item: ClothingItem,
        vibe: String
    ) -> Int {
        
        // combines the existing text properties for keywords of clothing style
        let description = [
            item.name,
            item.fit,
            item.occasion
        ]
            .joined(separator: " ")
            .lowercased()
        
        // each vibe has keywords that suggest us a matching style
        let keywords: [String]
        
        switch vibe {
            
        case "Casual":
            keywords = [
                "jeans", "denim", "t-shirt", "tee",
                "sneaker", "casual", "flannel"
            ]
            
        case "Cozy":
            keywords = [
                "sweater", "hoodie", "knit",
                "fleece", "cardigan", "cozy",
                "loose", "relaxed", "boot"
            ]
            
        case "Sport":
            keywords = [
                "athletic", "sport", "running",
                "legging", "jogger", "sneaker",
                "shorts", "active"
            ]
            
        case "Chic":
            keywords = [
                "blazer", "tailored", "dress",
                "formal", "elegant", "fitted",
                "trousers", "loafer", "heels"
            ]
            
        case "Streetwear":
            keywords = [
                "oversized", "baagy", "hoodier",
                "cargo", "graphic", "street",
                "sneaker", "high-top"
            ]
            
        default:
            keywords = []
        }
        
        // 2 points = matching keyword
        return keywords.reduce(0) { score, keyword in
            score + (description.contains(keyword) ? 2 : 0)
        }
    }
        
        
        // MARK: - Weather Compatibility
        
        private func weatherScore(
            for item: ClothingItem,
            temperature: Double?,
            weatherCode: Int?
        ) -> Int {
            
            // If no weather data is available, use vibe scoring only.
            guard temperature != nil || weatherCode != nil else {
                return 0
            }
            
            let description = [
                item.name,
                item.weather,
                item.fit
            ]
                .joined(separator: " ")
                .lowercased()
            
            var score = 0
            
            // STEP 1: Temperature suitability.
            if let temperature = temperature {
                
                if temperature >= 80 {
                    // HOT WEATHER: prefer light clothing.
                    let warmKeywords = [
                        "t-shirt", "tee", "tank", "shorts",
                        "linen", "cotton", "light", "summer",
                        "sandal", "breathable"
                    ]
                    
                    let heavyKeywords = [
                        "sweater", "hoodie", "fleece",
                        "coat", "jacket", "wool",
                        "thermal", "winter"
                    ]
                    
                    if warmKeywords.contains(where: {
                        description.contains($0)
                    }) {
                        score += 5
                    }
                    
                    if heavyKeywords.contains(where: {
                        description.contains($0)
                    }) {
                        score -= 6
                    }
                    
                    if item.weather.lowercased() == "hot" {
                        score += 5
                    }
                    
                    if item.weather.lowercased() == "cold" {
                        score -= 5
                    }
                    
                } else if temperature < 60 {
                    // COLD WEATHER: prefer warmer clothing.
                    let coldKeywords = [
                        "sweater", "hoodie", "fleece",
                        "coat", "jacket", "wool",
                        "knit", "boot", "thermal",
                        "winter"
                    ]
                    
                    let lightKeywords = [
                        "tank", "shorts", "sandal",
                        "summer"
                    ]
                    
                    if coldKeywords.contains(where: {
                        description.contains($0)
                    }) {
                        score += 5
                    }
                    
                    if lightKeywords.contains(where: {
                        description.contains($0)
                    }) {
                        score -= 5
                    }
                    
                    if item.weather.lowercased() == "cold" {
                        score += 5
                    }
                    
                    if item.weather.lowercased() == "hot" {
                        score -= 5
                    }
                    
                } else {
                    // MILD WEATHER: prefer everyday layers.
                    let mildKeywords = [
                        "jeans", "denim", "shirt",
                        "sneaker", "cardigan", "casual"
                    ]
                    
                    if mildKeywords.contains(where: {
                        description.contains($0)
                    }) {
                        score += 3
                    }
                    
                    if item.weather.lowercased() == "mild" {
                        score += 4
                    }
                }
            }
            
            // STEP 2: Rain suitability.
            if isRain(weatherCode) {
                
                let rainKeywords = [
                    "rain", "waterproof", "water-resistant",
                    "water resistant", "raincoat",
                    "boots"
                ]
                
                if rainKeywords.contains(where: {
                    description.contains($0)
                }) {
                    score += 6
                }
                
                // Discourage clearly unsuitable rainy-day footwear.
                if item.category == "Shoes" &&
                    (description.contains("sandal") ||
                     description.contains("heels")) {
                    score -= 6
                }
                
                if item.weather.lowercased() == "rainy" {
                    score += 5
                }
            }
            
            return score
        }
        
        // MARK: - Rain Detection
        
        // WMO weather codes used by Open-Meteo.
        private func isRain(_ code: Int?) -> Bool {
            
            guard let code = code else {
                return false
            }
            
            return (51...67).contains(code) ||
            (80...82).contains(code) ||
            (95...99).contains(code)
        }
    }
