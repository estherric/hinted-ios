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

struct ClothingItem: Identifiable, Codable, Equatable {

    // Unique identifier for each clothing item
    var id = UUID()

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

    // MARK: - Channel3 API Properties

    // Original product ID to prevent duplicates
    var productID: String? = nil

    // Product image from Channel3
    var imageURL: String? = nil

    // Product brand
    var brand: String? = nil
}
