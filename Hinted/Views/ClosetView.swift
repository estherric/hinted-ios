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
    
    // Text entered by user in the search bar
    @State private var searchText = ""
    
    // Currently selected clothing category
    @State private var selectedCategory = "All"
    
    // Controls whether Add a Piece is displayed
    @State private var showAddPiece = false
    
    // Clothing categories
    private let categories = [
        "All",
        "Tops",
        "Bottoms",
        "Shoes",
        "Outerwear"
    ]
    
    // Temporary clothing items
    @State private var clothingItems: [ClothingItem] = [
        
        ClothingItem(name: "Navy Sweater", category: "Tops", color: "Navy", imageName: "tshirt.fill"),
        
        ClothingItem(name: "Blue Jeans", category: "Bottoms", color: "Blue", imageName: "square.fill"),
        
        ClothingItem(name: "White Sneakers", category: "Shoes", color: "White", imageName: "shoe"),
        
        ClothingItem(name: "Black Jacket", category: "Outerwear", color: "Black", imageName: "jacket")
        
    ]
    
    // MARK - Filter Clothing
    
    private var filteredItems: [ClothingItem] {
        
        clothingItems.filter { item in
            
            // Check the selected category
            let matchesCategory =
                selectedCategory == "All" ||
                item.category == selectedCategory
            
            // Check the search bar
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
                                .font(.system(size:18, weight:.bold))
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

                                        // Display the user's uploaded photo
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(8)

                                    } else {

                                        // Display an SF Symbol if no photo exists
                                        Image(systemName: item.imageName)
                                            .font(.system(size: 55))
                                            .foregroundStyle(HintedColors.purple)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 130)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

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
    ClosetView()
}
