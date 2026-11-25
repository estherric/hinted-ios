
import Foundation

// reps a clothing product returned by Channel3
struct ClothingProduct: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let brands: [ClothingBrand]
    let images: [ClothingImage]

    // get the main product image
    var mainImageURL: String? {
        return images.first(where: { $0.isMainImage })?.url
            ?? images.first?.url
    }

    // get the first brand name
    var brandName: String {
        return brands.first?.name ?? "Unknown Brand"
    }
}

// reps the clothing brand
struct ClothingBrand: Codable {
    let id: String
    let name: String
}

// reps a clothing product image
struct ClothingImage: Codable {
    let url: String
    let cleanedURL: String?
    let isMainImage: Bool
    let shotType: String?
    let altText: String?

    enum CodingKeys: String, CodingKey {
        case url
        case cleanedURL = "cleaned_url"
        case isMainImage = "is_main_image"
        case shotType = "shot_type"
        case altText = "alt_text"
    }
}
