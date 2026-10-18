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
    
    var body: some View {
        
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
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Outfit Section
                    Text("Today's Outfit")
                        .font(HintedFonts.adLib(15))
                    
                    // Closet Section
                    Text("Your personalized outfit will appear here.")
                        .font(.subheadline)
                        .foregroundStyle(.black)
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

// MARK - Preview
    #Preview {
        HomeDashboardView(
            selectedTab: .constant(0),
            showDashboard: .constant(true)
        )
}

