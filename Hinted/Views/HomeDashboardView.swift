//
//  HomeDashboardView.swift
//  Hinted
//
//  Created by esther ricardo on 10/17/26.
//
import SwiftUI

// MARK: - Home Dashboard

struct HomeDashboardView : View {
    
    // Controls which tab the user is viewing
    @Binding var selectedTab: Int
    
    // Allows us to return to the onboarding screen
    @Binding var showDashboard: Bool
    
    // Temporary data for the weather condition
    let temperature = 100
    let feelsLike = 102
    let city = "Los Angeles"
    let weatherCondition = "Sunny"
    
    // Returns the current weekday
    var weekday : String {
        Date.now.formatted(.dateTime.weekday(.wide))
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Dashboard Greeting
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // Welcome Message
                        Text("Good morning, Esther")
                            .font(HintedFonts.adLib(25))
                            .foregroundStyle(.black)
                        
                        // Date (Format: Weekday, Month Day)
                        Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                            .font(HintedFonts.adLib(14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                    }
                    
                    // MARK: - Weather Card
                    VStack(alignment: .leading, spacing: 15) {
                        
                        HStack(alignment: .center) {
                            
                            // Weather Location
                            VStack(alignment: .leading, spacing: 5) {
                                
                                // City
                                Text(city)
                                    .font(HintedFonts.adLib(25))
                                
                                // Weather Condition
                                Text("\(weatherCondition) • Feels like \(feelsLike)ºF")
                                    .font(.system(size: 13))
                            }
                            
                            Spacer()
                            
                            // Weather Icon
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 35))
                                .foregroundStyle(.black)
                            
                            // Temperature
                            Text("\(temperature)ºF")
                                .font(HintedFonts.adLib(27))
                        }
                        
                        Divider()
                        
                        Text("Your daily weather hint")
                            .font(HintedFonts.adLib(15))
                        
                        Text("Stay cool! Choose light, breathable clothing for today's outfit.")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HintedColors.lightYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // MARK - Today's Outfit
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Card Heading
                        HStack {
                            Text("Your Daily Hint")
                                .font(HintedFonts.adLib(15))
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "sparkles")
                                .foregroundStyle(.purple)
                        }
                        
                        // MARK: - Outfit Collage
                        ZStack {
                            
                            // Outfit Background
                            RoundedRectangle(cornerRadius: 15)
                                .fill(HintedColors.gray)
                            
                            // Top: from the import
                            Image("outfitTop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-10))
                                .offset(x: -80, y: -2)
                                .zIndex(1)
                            
                            // Bag: from the import
                            Image("outfitBag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-10))
                                .offset(x: 0, y: -2)
                                .zIndex(2)
                            
                            // Shoes: from the import
                            Image("outfitShoes")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-10))
                                .offset(x: 80, y: -2)
                                .zIndex(3)
                            
                        }
                        .frame(width: 210)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        // MARK: - Outfit Description
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("\(weekday)'s Choice")
                                .font(HintedFonts.adLib(12))
                                .foregroundStyle(.black)
                            
                            Text("A comfortable everyday look with a casual vibe")
                                .font(.subheadline)
                        }
                        
                        // MARK: - See This Outift Button
                        NavigationLink {
                            
                            // Connect "See this outfit" to the Outfit Details screen
                            OutfitDetailView()
                        } label: {
                            
                            HStack(spacing: 10) {
                                
                                Text("See this outfit")
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "arrow.right")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(HintedColors.purple)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HintedColors.lightYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer(minLength: 20)
                    
                }
                .padding(20)
            }
            .background(HintedColors.cream)
        }
    }
}

// MARK - Preview
    #Preview {
        HomeDashboardView(
            selectedTab: .constant(0),
            showDashboard: .constant(true)
        )
}

