
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
                    .disabled(
                        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || isLoading
                        )
                }
                .padding()

                if isLoading {
                    ProgressView("Loading clothing...")
                    Spacer()

                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                    Spacer()

                } else if products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)

                        Text("No clothing found")
                            .font(.headline)

                        Text("Try searching for something different.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    Spacer()

                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(products) { product in
                                VStack(alignment: .leading, spacing: 8) {

                                    // Product image
                                    GeometryReader { geometry in
                                        AsyncImage(
                                            url: URL(string: product.mainImageURL ?? "")
                                        ) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(
                                            width: geometry.size.width,
                                            height: 180
                                        )
                                    }
                                    .frame(height: 180)
                                    .background(Color.gray.opacity(0.05))
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )

                                    // Product name
                                    Text(product.title)
                                        .font(.subheadline)
                                        .lineLimit(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .leading
                                        )

                                    // Brand name
                                    Text(product.brandName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .topLeading
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Explore Clothing")
            .task {
                await loadClothing()
            }
        }
    }

    // Fetch clothing products from Channel3
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
