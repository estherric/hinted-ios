//
//  ClosetView.swift
//  Hinted
//
//  Created by esther ricardo on 11/7/26.
//

import SwiftUI

// MARK: - My Closet Screen

struct ClosetView: View {

    // MARK: - State Variables

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showAddPiece = false

    // Clothing categories
    private let categories = [
        "All",
        "Tops",
        "Bottoms",
        "Shoes",
        "Outerwear",
        "Other"
    ]

    // Shared clothing collection from ContentView
    @Binding var clothingItems: [ClothingItem]
    
    // Sample clothing displayed when the closet is empty
    private let sampleItems: [ClothingItem] = [
        ClothingItem(
            name: "Navy Sweater",
            category: "Tops",
            color: "Navy",
            imageName: "tshirt.fill"
        ),
        ClothingItem(
            name: "Blue Jeans",
            category: "Bottoms",
            color: "Blue",
            imageName: "square.fill"
        ),
        ClothingItem(
            name: "White Sneakers",
            category: "Shoes",
            color: "White",
            imageName: "shoe"
        ),
        ClothingItem(
            name: "Black Jacket",
            category: "Outerwear",
            color: "Black",
            imageName: "jacket"
        )
    ]

    // Show sample items only when the actual closet is empty
    private var displayedItems: [ClothingItem] {
        clothingItems.isEmpty ? sampleItems : clothingItems
    }

    // MARK: - Filter Clothing

    private var filteredItems: [ClothingItem] {
        displayedItems.filter { item in

            let matchesCategory =
                selectedCategory == "All" ||
                item.category == selectedCategory

            let matchesSearch =
                searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
        }
    }

    // MARK: - Grid Layout

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Main View

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Header

                    HStack {
                        Text("My Closet")
                            .font(HintedFonts.adLib(30))
                            .foregroundStyle(.black)

                        Spacer()

                        Button {
                            showAddPiece = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(HintedColors.purple)
                                .clipShape(Circle())
                        }
                    }

                    // MARK: - Search Bar

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)

                        TextField(
                            "Search your closet...",
                            text: $searchText
                        )
                        .font(.system(size: 15))
                    }
                    .padding(15)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                    // MARK: - Category Filters

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Text(category)
                                        .font(.system(
                                            size: 14,
                                            weight: .semibold
                                        ))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            selectedCategory == category
                                            ? HintedColors.purple
                                            : Color.white
                                        )
                                        .foregroundStyle(
                                            selectedCategory == category
                                            ? .white
                                            : .black
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    // MARK: - Clothing Grid

                    if filteredItems.isEmpty {

                        VStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 35))
                                .foregroundStyle(HintedColors.purple)

                            Text("No clothing items found.")
                                .font(.headline)

                            Text("Try another search or category.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)

                    } else {

                        LazyVGrid(columns: columns, spacing: 15) {

                            ForEach(filteredItems) { item in

                                // MARK: - Clothing Image

                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(HintedColors.gray)

                                    if let imageData = item.imageData,
                                       let image = UIImage(data: imageData) {

                                        // Display manually uploaded photo
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(8)

                                    } else if let imageURL = item.imageURL,
                                              let url = URL(string: imageURL) {

                                        // Display Channel3 product image
                                        AsyncImage(url: url) { phase in
                                            switch phase {

                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(8)

                                            case .failure(let error):
                                                VStack(spacing: 5) {
                                                    Image(systemName: "exclamationmark.triangle")
                                                        .foregroundStyle(.red)

                                                    Text("Image failed")
                                                        .font(.caption)
                                                }
                                                .onAppear {
                                                    print("Closet image error: \(error)")
                                                }

                                            default:
                                                ProgressView()
                                            }
                                        }

                                    } else {

                                        // Display placeholder icon
                                        Image(systemName: item.imageName)
                                            .font(.system(size: 55))
                                            .foregroundStyle(HintedColors.purple)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 130)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                            }
                        }
                    }

                    // MARK: - Add a Piece Button

                    Button {
                        showAddPiece = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus")

                            Text("Add a Piece")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(HintedColors.purple)
                        .clipShape(Capsule())
                    }
                }
                .padding(20)
            }
            .background(HintedColors.cream)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showAddPiece) {
                AddPieceView(clothingItems: $clothingItems)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ClosetView(clothingItems: .constant([]))
}
