//
//  EditPieceView.swift
//  Hinted
//
//  Created by esther ricardo on 11/9/26.
//

import SwiftUI
import SwiftData
import PhotosUI

// MARK: - Edit Clothing Item

struct EditPieceView: View {
    
    // the existing item we want to edit
    let item: ClothingItem
    
    // SwiftData and navigation
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Form State
    @State private var name: String
    @State private var category: String
    @State private var color: String
    @State private var weather: String
    @State private var fit: String
    @State private var occasion: String
    
    // MARK: - Photo State
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isLoadingPhoto = false
    @State private var errorMessage: String?
    
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
    
    // MARK: - Initializer
    
    init(item: ClothingItem) {
        
        self.item = item
        
        // FIlls the form w/ existing clothing details
        _name = State(initialValue: item.name)
        _category = State(initialValue: item.category)
        _color = State(initialValue: item.color)
        _weather = State(initialValue: item.weather)
        _fit = State(initialValue: item.fit)
        _occasion = State(initialValue: item.occasion)
        _imageData = State(initialValue: item.imageData)
    }
    
    // MARK: - Validation
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoadingPhoto
    }
    
    // MARK: - Main View
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Clothing Photo
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        
                        VStack(spacing: 12) {
                            
                            if let imageData,
                               let image = UIImage(data: imageData) {
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else {
                                
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 45))
                                    .foregroundStyle(HintedColors.purple)
                                
                                Text("Change clothing photo")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(HintedColors.purple)
                            }
                        
                        
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 230)
                        .background(HintedColors.lightYellow.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                    }
                    .buttonStyle(.plain)
                    
                    if isLoadingPhoto {
                        ProgressView("Loading photo ...")
                    }
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    // MARK: - Clothing Name
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Name")
                            .fontWeight(.semibold)
                        
                        TextField("Clothing name", text: $name)
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
                            options: colors)
                    }
                    
                    // MARK: - Weather and Fit
                    
                    HStack(spacing: 12) {
                        
                        dropdownField(
                            title: "Weather",
                            selection: $weather,
                            options: weatherOptions
                        )
                        
                        dropdownField(
                            title: "Fit",
                            selection: $fit,
                            options: fitOptions)
                    }
                    
                    // MARK: - Occasion
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Wear It For")
                            .fontWeight(.semibold)
                        
                        TextField(
                            "School, Going Out, Everyday...",
                            text: $occasion
                        )
                        .padding(14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // MARK: - Save Changes
                    
                    Button {
                        saveChanges()
                    } label: {
                        
                        HStack(spacing: 10) {
                            
                            Image(systemName: "checkmark")
                            
                            Text("Save Changes")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(
                            canSave ? HintedColors.purple : Color.gray
                        )
                        .clipShape(Capsule())
                    }
                    .disabled(!canSave)
                    
                } // End VStack
                .padding(20)
                
            } // End ScrollView
            .background(HintedColors.cream)
            .navigationTitle("Edit a Piece")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    // Close Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(HintedColors.purple)
                    }
                    .accessibilityLabel("Cancel editing")
                }
            }
            .onChange(of: selectedPhoto) {_, newPhoto in
                Task {
                    await loadPhoto(newPhoto)
                }
            }
            
        } // End NaviagtionStack
    } // End body
    
    // MARK: - Reusable Dropdown
    
    private func dropdownField(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            
            Picker(title, selection: selection) {
                
                ForEach(options, id:\.self) { option in
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
    
    // MARK: - Load New Photo
    
    @MainActor
    private func loadPhoto(_ photo: PhotosPickerItem?) async {
        
        guard let photo else { return }
        
        isLoadingPhoto = true
        errorMessage = nil
        
        defer {
            isLoadingPhoto = false
        }
        
        do {
            
            if let data = try await photo.loadTransferable(type: Data.self) {
                imageData = data
            } else {
                errorMessage = "Unable to load the selected photo."
            }
        } catch {
            errorMessage = "Unable to load the selected photo."
        }
    }
    
    // MARK: - Save Updated Item
    private func saveChanges() {

            guard canSave else { return }

            // Update the EXISTING SwiftData model
            item.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            item.category = category
            item.color = color
            item.weather = weather
            item.fit = fit
            item.occasion = occasion
            item.imageData = imageData

            do {

                try modelContext.save()

                // Close the form after saving
                dismiss()

            } catch {

                modelContext.rollback()
                errorMessage = "Unable to save your changes."
                print("Edit error: \(error)")
            }
        }
}
