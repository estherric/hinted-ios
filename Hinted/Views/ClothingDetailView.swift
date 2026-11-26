//
//  ClothingDetailView.swift
//  Hinted
//
//  Created by einguyen on 11/23/26.
//

import SwiftUI
import SwiftData

struct ClothingDetailView: View {

    // Selected Channel3 product
    let product: ClothingProduct

    // MARK: - SwiftData Storage

    // Provides the access to the shared clothing database
    @Environment(\.modelContext) private var modelContext

    // Automatically retrieves saved clothing from My Closet
    @Query private var clothingItems: [ClothingItem]

    // Selected clothing category
    @State private var selectedCategory = "Tops"

    private let categories = [
        "Tops",
        "Bottoms",
        "Shoes",
        "Outerwear",
        "Other"
    ]

    // Check if the product is already in the closet
    private var isAdded: Bool {
        clothingItems.contains {
            $0.productID == product.id
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Product Image

                AsyncImage(
                    url: URL(string: product.mainImageURL ?? "")
                ) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure:
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(HintedColors.purple)

                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // MARK: - Product Information

                VStack(alignment: .leading, spacing: 8) {

                    Text(product.brandName)
                        .font(.subheadline)
                        .foregroundStyle(HintedColors.purple)

                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }

                // MARK: - Description

                if let description = product.description,
                   !description.isEmpty {

                    Text("Description")
                        .font(.headline)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Category Selection

                VStack(alignment: .leading, spacing: 8) {

                    Text("Clothing Category")
                        .font(.headline)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .tint(HintedColors.purple)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(isAdded)
                }

                // MARK: - Add to Closet Button

                Button {
                    addToCloset()
                } label: {
                    HStack(spacing: 10) {

                        Image(systemName: isAdded ? "checkmark" : "plus")

                        Text(isAdded ? "Added to Closet" : "Add to Closet")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        isAdded ? Color.gray : HintedColors.purple
                    )
                    .clipShape(Capsule())
                }
                .disabled(isAdded)
            }
            .padding(20)
        }
        .background(HintedColors.cream)
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Add Product to Closet

    private func addToCloset() {

        // Prevent duplicate clothing items
        guard !isAdded else { return }

        // Convert the API product into a closet item
        let newItem = ClothingItem(
            name: product.title,
            category: selectedCategory,
            color: "Unknown",
            imageName: "tshirt.fill",
            productID: product.id,
            imageURL: product.mainImageURL,
            brand: product.brandName
        )

        // Insert the clothing item into the database
        modelContext.insert(newItem)

        do {

            // Save the new clothing item permanently.
            try modelContext.save()

            print("Successfully added \(product.title) to My Closet.")

        } catch {

            // Undo the insert if the saving fails.
            modelContext.rollback()

            print("Failed to save clothing: \(error.localizedDescription)")
        }
    }
}
