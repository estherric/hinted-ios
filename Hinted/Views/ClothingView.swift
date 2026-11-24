import SwiftUI

struct ClothingView: View {

    let apiKey: String

    // Shared clothing collection from ContentView
    @Binding var clothingItems: [ClothingItem]

    // MARK: - State Variables

    @State private var products: [ClothingProduct] = []
    @State private var searchText = "women casual tops"
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let clothingService = ClothingAPIService()

    // MARK: - Grid Layout

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Main View

    var body: some View {
        NavigationStack {
            VStack {

                // MARK: - Search Bar

                HStack {
                    TextField("Search clothing...", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    Button("Search") {
                        Task {
                            await loadClothing()
                        }
                    }
                    .disabled(
                        searchText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty || isLoading
                    )
                }
                .padding()

                // MARK: - Loading State

                if isLoading {

                    ProgressView("Loading clothing...")
                    Spacer()

                // MARK: - Error State

                } else if let errorMessage = errorMessage {

                    Text(errorMessage)
                        .foregroundStyle(.red)

                    Spacer()

                // MARK: - Empty State

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

                // MARK: - Clothing Grid

                } else {

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {

                            ForEach(products) { product in

                                // Open product details when tapped
                                NavigationLink {
                                    ClothingDetailView(
                                        product: product,
                                        clothingItems: $clothingItems
                                    )
                                } label: {

                                    VStack(
                                        alignment: .leading,
                                        spacing: 8
                                    ) {

                                        // Product image
                                        GeometryReader { geometry in
                                            AsyncImage(
                                                url: URL(
                                                    string: product.mainImageURL ?? ""
                                                )
                                            ) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()

                                                case .failure:
                                                    Image(systemName: "tshirt.fill")
                                                        .font(.system(size: 40))
                                                        .foregroundStyle(.secondary)

                                                default:
                                                    ProgressView()
                                                }
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
                                            .foregroundStyle(.primary)
                                            .lineLimit(3)
                                            .fixedSize(
                                                horizontal: false,
                                                vertical: true
                                            )
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )

                                        // Product brand
                                        Text(product.brandName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .topLeading
                                    )
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
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

    // MARK: - Load Clothing from Channel3 API

    @MainActor
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

// MARK: - Preview

#Preview {
    ClothingView(
        apiKey: "",
        clothingItems: .constant([])
    )
}
