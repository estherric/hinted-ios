//
//  SavedLook.swift
//  Hinted
//
//  Created by einguyen on 11/26/26.
//

import Foundation
import SwiftData

// MARK: - Saved Look Model

@Model
final class SavedLook {

    // Unique identifier
    @Attribute(.unique)
    var id: UUID

    // Outfit information
    var vibe: String
    var dateSaved: Date

    // Weather when the outfit was generated
    var temperature: Double?

    // Clothing pieces included in the outfit
    var top: ClothingItem?
    var bottom: ClothingItem?
    var shoes: ClothingItem?
    var outerwear: ClothingItem?

    // MARK: - Initializer

    init(
        vibe: String,
        temperature: Double? = nil,
        top: ClothingItem,
        bottom: ClothingItem,
        shoes: ClothingItem,
        outerwear: ClothingItem? = nil
    ) {
        self.id = UUID()
        self.vibe = vibe
        self.dateSaved = Date()
        self.temperature = temperature
        self.top = top
        self.bottom = bottom
        self.shoes = shoes
        self.outerwear = outerwear
    }
}
