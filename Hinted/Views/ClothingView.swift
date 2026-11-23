
import SwiftUI

struct ClothingView: View {

    @State private var products: [ClothingProduct] = []
    @State private var searchText = "women casual tops"
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let clothingService = ClothingAPIService()

    // API key supplied during local development only
    let apiKey: String

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search clothing...", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    Button("Search") {
                        Task {
                            await loadClothing()
                        }
                    }
                }
                .padding()

                if isLoading {
                    ProgressView("Loading clothing...")
                    Spacer()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(products) { product in
                                VStack(alignment: .leading, spacing: 8) {

                                    if let imageURL = product.mainImageURL,
                                       let url = URL(string: imageURL) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(height: 180)
                                        .clipped()
                                    }

                                    Text(product.title)
                                        .font(.subheadline)
                                        .lineLimit(2)

                                    Text(product.brandName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Explore Clothing")
            .task {
                await loadClothing()
            }
        }
    }

    // fetch clothing products from Channel3
    func loadClothing() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await clothingService.searchClothing(
                query: searchText,
                apiKey: apiKey
            )
        } catch {
            errorMessage = "Failed to load clothing: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
