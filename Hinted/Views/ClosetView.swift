//
//  ClosetView.swift
//  Hinted
//
//  Created by esther ricardo on 11/7/26.
//

import SwiftUI
import SwiftData

// MARK: - My Closet Screen

struct ClosetView: View {

    // MARK: Environment
    @Environment(\.modelContext) private var modelContext

    // MARK: - State Variables

    // Text entered by user in the search bar
    @State private var searchText = ""

    // Currently selected clothing category
    @State private var selectedCategory = "All"

    // Controls whether Add a Piece is displayed
    @State private var showAddPiece = false

    // Clothing item selected for editing
    @State private var itemToEdit: ClothingItem?

    // Clothing item selected for deletion
    @State private var itemToDelete: ClothingItem?
    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false

    // Clothing categories
    private let categories = [
        "All",
        "Tops",
        "Bottoms",
        "Shoes",
        "Outerwear",
        "Other"
    ]

    // MARK: - Saved Clothing Items
    @Query(sort: \ClothingItem.dateAdded, order:.reverse)
    private var clothingItems : [ClothingItem]

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

                                // VStack groups the image and buttons vertically
                                VStack(spacing: 10) {

                                    // MARK: - Clothing Image (EXISTING CODE)

                                    ZStack {

                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(HintedColors.gray)

                                        if let imageData = item.imageData,
                                           let image = UIImage(data: imageData) {

                                            // case 1: Display the user's uploaded photo
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(8)

                                        } else if let imageURL = item.imageURL,
                                                  let url = URL(string: imageURL) {

                                            // case 2: Display the imported clothing from Channel3
                                            // AsyncImage downloads and displays the profuct photo
                                            AsyncImage(url: url) { phase in

                                                switch phase {

                                                case.success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(8)

                                                case.failure:
                                                    Image(systemName: "photo")
                                                        .font(.system(size: 40))
                                                        .foregroundStyle(HintedColors.purple)

                                                default:
                                                    ProgressView()
                                                }
                                            }

                                        } else {

                                            // case 3: No photograph is available.
                                            Image(systemName: item.imageName)
                                                .font(.system(size: 45))
                                                .foregroundStyle(HintedColors.purple)
                                        }

                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                    // MARK: - Edit and Delete Buttons

                                    HStack(spacing: 8) {

                                        // Edit Button
                                        Button {
                                            itemToEdit = item
                                        } label: {

                                            Label("Edit", systemImage: "pencil")
                                                .font(.system(size: 12, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .foregroundStyle(HintedColors.purple)
                                                .background(HintedColors.purple.opacity(0.10))
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }

                                        // Delete Button
                                        Button {
                                            itemToDelete = item
                                            showDeleteConfirmation = true
                                        } label: {

                                            Label("Delete", systemImage: "trash")
                                                .font(.system(size: 12, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .foregroundStyle(.red)
                                                .background(Color.red.opacity(0.10))
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    .buttonStyle(.plain)

                                } // End VStack

                            } // End ForEach

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

                AddPieceView()
            }

            // MARK: - Edit Clothing Sheet
            .sheet(item: $itemToEdit) { item in
                EditPieceView(item: item)
            }

            // MARK: - Delete Confirmation Diaglog

            // Ask the user before deleting a clothing item
            .confirmationDialog(
                "Delete this clothing item?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {

                // Delete the selected item
                Button("Delete Item", role: .destructive) {
                    deleteClothingItem()
                }

                // Cancel the deletion
                Button("Cancel", role: .cancel) {
                    itemToDelete = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }

            // MARK: - Delete Error Alert
            .alert("Unable to Delete", isPresented: $showDeleteError) {

                Button("OK", role: .cancel) {}

            } message: {
                Text("The clothing item could not be deleted. Please try again.")
            }

        } // End of NavigationStack

    } // End of body

        // MARK: - Delete Clothing Item

        private func deleteClothingItem() {

            // 1. Make sure a clothing item was selected
            guard let item =  itemToDelete else {
                return
            }

            // 2. Remove the selected item from SwiftData
            modelContext.delete(item)

            do {
                // saves the deletion
                try modelContext.save()
                itemToDelete = nil

            } catch {
                // undo uncommitted or recent changes
                modelContext.rollback()
                showDeleteError = true
                itemToDelete = nil

                print("Delete error: \(error)")
            }
        }

    } // End ClosetView


    // MARK: - Preview

    #Preview {
        ClosetView()
            .modelContainer(for: ClothingItem.self, inMemory: true)
    }
