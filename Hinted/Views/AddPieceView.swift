//
//  AddPieceView.swift
//  Hinted
//
//  Created by esther ricardo on 11/7/26.
//

import SwiftUI
import PhotosUI
import SwiftData

// MARK: - Add a Piece Screen

struct AddPieceView: View {
    
    // Access the SwiftData storage
    @Environment(\.modelContext) private var modelContext
    
    // Allows this screen to close after saving
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Form State
    
    @State private var name = ""
    @State private var category = "Top"
    @State private var color = "Black"
    @State private var weather = "Any"
    @State private var fit = "Regular"
    @State private var occasion = ""
    
    // MARK: - Photo Selection
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isLoadingPhoto = false
    @State private var photoError: String?
    @State private var saveError: String?
    
    // MARK: - Dropdown Options
    
    private let categories = [
        "Tops", "Bottoms", "Shoes", "Outerwear"
    ]
    
    private let colors = [
        "Black", "White", "Gray", "Beige",
        "Brown", "Blue", "Red", "Green",
        "Yellow", "Purple", "Pink", "Other"
    ]
    
    private let weatherOptions = [
        "Any", "Hot", "Mild", "Cold", "Rainy"
    ]
    
    private let fitOptions = [
        "Slim", "Regular", "Relaxed", "Oversized"
    ]
    
    // Prevent saving an empty clothing name
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoadingPhoto
    }
    
    // MARK: - Main View
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Photo Upload
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        
                        VStack(spacing: 12) {
                            
                            if let imageData,
                               let image = UIImage(data: imageData) {
                                
                                // Displays the selected clothing photo
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                
                            } else {
                                
                                // Placeholder when no photo is selected
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 45))
                                    .foregroundStyle(HintedColors.purple)
                                
                                Text("Choose a clothing photo")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(HintedColors.purple)
                                
                                Text("Select from your photo library")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 230)
                        .background(HintedColors.lightYellow.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                }
                .buttonStyle(.plain)
                    
                // MARK: - Photo Loading
                
                if isLoadingPhoto {
                    ProgressView("Loading photo...")
                        .font(.subheadline)
                }
                
                // MARK: - Photo Error
                    
                if let photoError {
                    
                    Text(photoError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                    
                // MARK: - Photo Error
                    
                if let saveError {
                        
                    Text(saveError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                // MARK: - Clothing Name
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Name")
                        .font(.system(size: 14, weight: .semibold))
                    
                    TextField("e.g. Beige Sweater", text: $name)
                        .padding(14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // MARK: - Category and Color
                
                HStack(spacing: 12) {
                    
                    dropdownField(
                        title: "Category",
                        selection: $category,
                        options: categories
                    )
                    
                    dropdownField(
                        title: "Color",
                        selection: $color,
                        options: colors
                    )
                }
                
                // MARK: Weather and Fit
                
                HStack(spacing: 12) {
                    
                    dropdownField(
                        title: "Weather",
                        selection: $weather,
                        options: weatherOptions
                    )
                    
                    dropdownField(
                        title: "Fit",
                        selection: $fit,
                        options: fitOptions
                    )
                }
                
                // MARK: - Occasion
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Wear It For")
                        .font(.system(size:14, weight: .semibold))
                    
                    TextField(
                        "School, Going Out, Everyday...",
                        text: $occasion
                    )
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // MARK: - Save Clothing Item
                
                Button {
                    addClothingItem()
                } label: {
                    
                    HStack(spacing: 10) {
                        
                        Image(systemName: "plus")
                        
                        Text("Add to my closet")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        canSave
                        ? HintedColors.purple
                        : Color.gray
                    )
                    .clipShape(Capsule())
                    
                }
                    
                .disabled(!canSave)

            } // End of main VStack
            .padding(20)
                
        } // End of ScrollView
        .background(HintedColors.cream)
        .navigationTitle("Add a Piece")
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: - Close Add a Piece Screen
            
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button {
                    
                    dismiss()
                    
                } label: {

                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(HintedColors.purple)
                        .clipShape(Circle())
    
                }
                .accessibilityLabel("Close Add a Piece")
            }
        }

        // MARK: - Detect Selected Photo
        .onChange(of: selectedPhoto) {_, newPhoto in
            
            Task {
                await loadPhoto(newPhoto)
            }
        }
            
    } // End of NavigationStack
            
} // End of body
    
    // MARK: - Resuable Dropdown
    
    private func dropdownField(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            
            Picker(title, selection: selection) {
                
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .tint(HintedColors.purple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(6)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Load Selected Photo
    
    @MainActor
    private func loadPhoto(_ photo: PhotosPickerItem?) async {
        
        isLoadingPhoto = true
        photoError = nil
        
        // Clear the previous image
        imageData = nil
        
        guard let photo else {
            isLoadingPhoto = false
            return
        }
        
        do {
            if let data = try await photo.loadTransferable(type: Data.self) {
                imageData = data
            } else {
                photoError = "Could not load this photo."
            }
        } catch {
            photoError = "Unable to load the selected photo."
        }
        
        isLoadingPhoto = false
    }
    
    // MARK: Add Clothing to Closet
    
    private func addClothingItem() {
        
        // Do not save if required info is missing
        guard canSave else { return }
        
        // Create a new clothing item
        let newItem = ClothingItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            color: color,
            imageName: "tshirt.fill",
            imageData: imageData,
            weather: weather,
            fit: fit,
            occasion: occasion
        )
        
        // Insert the item into SwiftData
        modelContext.insert(newItem)
        
        do {
            // Write the new item to persistent storage
            try modelContext.save()
            
            // Closes the Add a Piece screen the form only after saving succeeds
            dismiss()
            
        } catch {
            
            // Undo the failed insertion
            modelContext.delete(newItem)
            
            // Display an error msg
            saveError = "Couldn't save your clothing item. Please try again."
            
            print("SwiftData save error: \(error)")
            
        }
    }
    
} // End of AddPieceView

// MARK: - Preview

#Preview {
    AddPieceView()
        .modelContainer(for: ClothingItem.self, inMemory: true)
}
