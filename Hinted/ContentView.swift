// xcode: set sdk=iOS


import SwiftUI
import UIKit

// MARK: - HINTED Color Palette

enum HintedColors {
    static let yellow = Color(red: 1.0, green: 0.80, blue: 0.10)
    static let cream = Color(red: 1.0, green: 0.99, blue: 0.94)
    static let purple = Color(red: 0.38, green: 0.28, blue: 0.65)
    static let lightYellow = Color(red: 0.97, green: 0.91, blue: 0.45)
    static let gray = Color(red: 0.87, green: 0.87, blue: 0.87)
}

// MARK: - HINTED Typography

// We can reuse the font style
// syntax: .font(HintedFonts.adLib())

enum HintedFonts {
    static func adLib(_ size: CGFloat) -> Font {
        return .custom("AdLibBT-Regular", size: size)
    }
}

// MARK: - Main Application View

struct ContentView: View {

    // Temporary authentication state
    @State private var showDashboard = false

    // Selected tab
    @State private var selectedTab = 0

    // Shared clothing collection
    @State private var clothingItems: [ClothingItem] = []

    // Key used to store the closet locally
    private let closetStorageKey = "savedClothingItems"

    var body: some View {
        Group {
            if showDashboard {
                TabView(selection: $selectedTab) {

                    // Home
                    HomeDashboardView(
                        selectedTab: $selectedTab,
                        showDashboard: $showDashboard
                    )
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                    // Closet
                    ClosetView(clothingItems: $clothingItems)
                        .tabItem {
                            Label("Closet", systemImage: "tshirt")
                        }
                        .tag(1)

                    // Explore
                    ClothingView(
                        apiKey: Bundle.main.object(
                            forInfoDictionaryKey: "CHANNEL3_API_KEY"
                        ) as? String ?? "",
                        clothingItems: $clothingItems
                    )
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                    .tag(4)

                    // Vibe
                    VibeView()
                        .tabItem {
                            Label("Vibe", systemImage: "sparkles")
                        }
                        .tag(2)

                    // Saved Looks
                    SavedLooksView()
                        .tabItem {
                            Label("Saved", systemImage: "bookmark")
                        }
                        .tag(3)
                }
                .tint(HintedColors.purple)

            } else {

                // Onboarding
                OnboardingView(
                    showDashboard: $showDashboard
                )
            }
        }

        // Load saved clothing when the app opens
        .onAppear {
            loadCloset()
        }

        // Automatically save whenever the closet changes
        .onChange(of: clothingItems) { _, _ in
            saveCloset()
        }
    }

    // MARK: - Save Closet

    private func saveCloset() {
        do {
            let data = try JSONEncoder().encode(clothingItems)
            UserDefaults.standard.set(data, forKey: closetStorageKey)
        } catch {
            print("Failed to save closet: \(error)")
        }
    }

    // MARK: - Load Closet

    private func loadCloset() {
        guard let data = UserDefaults.standard.data(
            forKey: closetStorageKey
        ) else {
            return
        }

        do {
            clothingItems = try JSONDecoder().decode(
                [ClothingItem].self,
                from: data
            )
        } catch {
            print("Failed to load closet: \(error)")
        }
    }
}

// MARK: - Onboarding Screen

struct OnboardingView: View {

    @Binding var showDashboard: Bool

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                // HINTED Logo
                VStack(spacing: 6) {

                    Text("WELCOME TO")
                        .font(HintedFonts.adLib(30))
                        .foregroundStyle(.black)

                    Image("hintedLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325, height: 85)
                        .accessibilityLabel("HINTED Logo")
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                // Featured Outfit Card
                HStack(spacing: 25) {

                    Image("outfitTop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 120)
                        .scaleEffect(2)
                        .offset(x: 30, y: -15)

                    Image("outfitBag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                        .scaleEffect(1.9)
                        .offset(x: 0, y: 20)

                    Image("outfitShoes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                        .scaleEffect(1.9)
                        .offset(x: -30, y: -10)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 230)
                .background(HintedColors.gray)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )

                // Description
                VStack(alignment: .leading, spacing: 8) {

                    Text("Curated outfits. Zero overthinking.")
                        .font(HintedFonts.adLib(25))

                    Text("Meet your AI closet companion. Get Dress for your plans, weather, and your mood – all in one.")
                        .font(HintedFonts.adLib(12))
                        .foregroundStyle(.secondary)
                }

                // MARK: Closet and Sign In Button

                VStack(spacing: 12) {

                    // Build Closet Button
                    Button {
                        showDashboard = true
                    } label: {

                        HStack {

                            Image(systemName: "arrow.right")
                                .fontWeight(.semibold)

                            Text("Let's build your closet")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(HintedColors.purple)
                        .clipShape(Capsule())
                    }

                    // Sign In Button
                    Button {
                        print("Sign In tapped!")
                    } label: {

                        HStack(spacing: 4) {

                            Text("Already have a closet?")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)

                            Text("Sign in")
                                .fontWeight(.semibold)
                                .foregroundStyle(HintedColors.purple)
                                .underline()
                        }
                        .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                    .multilineTextAlignment(.center)
                }
            }
            .padding(20)
        }
        .background(HintedColors.cream)
    }
}

// MARK: - Vibe Screen

struct VibeView: View {

    @State private var selectedVibe = "Casual"

    let vibes = [
        "Casual",
        "Cozy",
        "Sporty",
        "Chic",
        "Streetwear"
    ]

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                Text("What's the vibe?")
                    .font(.custom("AdLibBT-Regular", size: 30))
                    .fontWeight(.bold)

                Text("Choose your style for today.")
                    .foregroundStyle(.secondary)

                // Vibe Selection Buttons
                ForEach(vibes, id: \.self) { vibe in

                    Button {
                        selectedVibe = vibe
                    } label: {

                        HStack {

                            Text(vibe)

                            Spacer()

                            if selectedVibe == vibe {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedVibe == vibe
                            ? HintedColors.purple
                            : .white
                        )
                        .foregroundStyle(
                            selectedVibe == vibe
                            ? .white
                            : .black
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(HintedColors.cream)
            .navigationTitle("Find My Outfit")
        }
    }
}

// MARK: - Saved Looks Screen

struct SavedLooksView: View {

    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Image(systemName: "bookmark.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(HintedColors.purple)

                Text("No saved looks yet!")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Your favorite outfits will appear here.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(HintedColors.cream)
            .navigationTitle("Saved Looks")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
