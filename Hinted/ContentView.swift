// xcode: set sdk=iOS


import SwiftUI
import UIKit
import SwiftData

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

    var body: some View {
        Group {
            if showDashboard {
                TabView(selection: $selectedTab) {

                    // MARK: Home Tab
                    HomeDashboardView(
                        selectedTab: $selectedTab,
                        showDashboard: $showDashboard
                    )
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                    // MARK: - Closet Tab
                    ClosetView()
                        .tabItem {
                            Label("Closet", systemImage: "tshirt")
                        }
                        .tag(1)

                    // MARK: - Explore Tab
                    ClothingView(
                        apiKey: Bundle.main.object(
                            forInfoDictionaryKey: "CHANNEL3_API_KEY"
                        ) as? String ?? ""
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
    
    // MARK: - Clothing from My Closet
    
    // automatically retrieves saved clothing from SwiftData
    @Query private var clothingItems: [ClothingItem]
    
    // MARK: Outfit Recommendation
    
    // stores the generated outfit so it can appear on screen
    @State private var recommendedOutfit: RecommendedOutfit?
    
    // Handles the outfit logic of the selection
    private let recommendationService = OutfitRecommendationService()
    
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
            
            ScrollViewReader { proxy in
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("What's the vibe?")
                            .font(.custom("AdLibBT-Regular", size: 30))
                            .fontWeight(.bold)
                        
                        Text("Choose your style for today.")
                            .foregroundStyle(.secondary)
                        
                        // MARK: - Vibe Selection Grid
                        // display vibe options in two columns
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            
                            ForEach(vibes, id: \.self) { vibe in
                                
                                Button {
                                    // stores the vibe selected by the user
                                    selectedVibe = vibe
                                    
                                    // clear the previous recommendation
                                    // bc the selected vibe has changed
                                    recommendedOutfit = nil
                                    
                                } label: {
                                    
                                    HStack(spacing: 8) {
                                        
                                        Text(vibe)
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        Spacer(minLength: 0)
                                        
                                        if selectedVibe == vibe {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 65)
                                    .background(
                                        selectedVibe == vibe
                                        ? HintedColors.purple
                                        : Color.white
                                    )
                                    .foregroundStyle(
                                        selectedVibe == vibe
                                        ? Color.white
                                        : Color.black
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 14)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        } // End of ForEach
                        
                        // MARK: - Generate Outfit Button
                        
                        Button {
                            // asks the recommendation service to select clothing
                            recommendedOutfit = recommendationService.generateOutfit(
                                from: clothingItems,
                                vibe: selectedVibe
                            )
                                          
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "sparkles")
                                    
                                    Text("Generate My Outfit")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(HintedColors.purple)
                                .clipShape(Capsule())
                            }
                                          .padding(.top, 12)
                        
                        // MARK: - Recommended Outfit Display
                        
                        if let outfit = recommendedOutfit {
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("Your Outfit Recommendation")
                                    .font(HintedFonts.adLib(18))
                                    .foregroundStyle(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                
                                OutfitItemCardView(item: outfit.top, category: "Top")
                                OutfitItemCardView(item: outfit.bottom, category: "Bottom")
                                OutfitItemCardView(item: outfit.shoes, category: "Shoes")
                                
                                // outerwear is optional
                                if let outerwear = outfit.outerwear {
                                    OutfitItemCardView(item: outerwear, category: "Outerwear")
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .id("outfitRecommendation")
                            
                        } else if clothingItems.filter({$0.category == "Tops"}).isEmpty ||
                                    clothingItems.filter({$0.category == "Bottoms"}).isEmpty ||
                                    clothingItems.filter({$0.category == "Shoes"}).isEmpty {
                            
                            Text("Add at least one top, one bottom, and one pair of shoes to My Closet to generate an outfit.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                        }
                        
                    } // End of main VStack
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                } // End of ScrollView
                
                // when an outfit appears -> scroll to its card
                // runs after SwiftUI observes the state change
                .onChange(of: recommendedOutfit != nil) {_, hasOutfit in
                    
                    guard hasOutfit else { return }
                    
                    // scroll to the recommendation outfit after it appears
                    withAnimation(.easeInOut(duration: 0.4)) {
                        proxy.scrollTo(
                            "outfitRecommendation",
                            anchor: .top
                        )
                    }
                    
                }
                .safeAreaPadding(.bottom, 32)
                .background(HintedColors.cream)
                .toolbar(.hidden, for: .navigationBar)
                
            } // End of ScrollViewReader
            
        } // End of NavigationStack
        
    } // End of body
    
} // End of VibeView

// MARK: - Saved Looks Screen

struct SavedLooksView: View {

    var body: some View {

        NavigationStack {
            ScrollView {
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
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: ClothingItem.self, inMemory: true)
}
