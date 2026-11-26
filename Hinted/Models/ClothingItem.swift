//
//  ClothingItem.swift
//  Hinted
//
//  Created by esther ricardo on 11/7/26.
//

// this file represents the info used by our app i.e. the clothing items

// for data storage, dates, networking, and files
import Foundation
import SwiftData

// MARK: - Clothing Item Model

@Model
final class ClothingItem {

    // Unique identifier
    @Attribute(.unique)
    var id: UUID

    // Basic clothing information
    var name: String
    var category: String
    var color: String
    var imageName: String

    // Uploaded clothing photo
    @Attribute(.externalStorage)
    var imageData: Data?

    // Outfit recommendation information
    var weather: String
    var fit: String
    var occasion: String

    // Date the item was added
    var dateAdded: Date
    
    // MARK: - Channel3 API Properties
    
    // Unique ID of a product from Channel3
    var productID: String?
    
    // URL of the product's image
    var imageURL: String?
    
    // Brand of the clothing product
    var brand: String?

    // MARK: - Initializer

    init(
        name: String,
        category: String,
        color: String,
        imageName: String = "tshirt.fill",
        imageData: Data? = nil,
        weather: String = "Any",
        fit: String = "Regular",
        occasion: String = "",
        productID: String? = nil,
        imageURL: String? = nil,
        brand: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.color = color
        self.imageName = imageName
        self.imageData = imageData
        self.weather = weather
        self.fit = fit
        self.occasion = occasion
        self.dateAdded = Date()
        self.productID = productID
        self.imageURL = imageURL
        self.brand = brand
    }
}

