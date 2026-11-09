//
//  ClothingItem.swift
//  Hinted
//
//  Created by esther ricardo on 11/7/26.
//

// this file represents the info used by our app i.e. the clothing items

// for data storage, dates, networking, and files
import Foundation

// MARK: - Clothing Item Model

// every clothing item is unique from other instance (or clothing obj)
struct ClothingItem: Identifiable {
    
    // Unique identifier for each clothing item
    let id = UUID()
    
    // Basic clothing info
    var name: String
    var category: String
    var color: String
    
    // Temporary icon for clothing item (SF Symbol)
    var imageName: String
    
    // Uploaded clothing photo
    var imageData: Data? = nil
    
    // Additional info for recommendations
    var weather: String = "Any"
    var fit: String = "Regular"
    var occassion: String = ""
}
