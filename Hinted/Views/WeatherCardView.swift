//
//  WeatherCardView.swift
//  Hinted
//
//  Created by esther ricardo on 11/16/26.
//

import SwiftUI

// MARK: - Live Weather Card

struct WeatherCardView : View {
    
    // MARK: - Weather State
    
    // stores the weather received from Open-Meteo
    @State private var weather: WeatherData?
    
    // tracks whether the weather is loading
    @State private var isLoading = true
    
    // stores an error msg if the API req fails
    @State private var errorMessage: String?
    
    // MARK: - API service
    private let weatherService = WeatherService()
    
    // MARK: - Main View
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            // MARK: - Card Weather Header
            
            HStack(alignment: .center, spacing: 12) {
                
                // MARK: - City and Weather Condition
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    
                    // City name
                    Text("Fullerton")
                        .font(HintedFonts.adLib(25))
                        .foregroundStyle(.black)
                    
                    // displays the current weather condition
                    if let weather {
                        
                        Text(weather.conditionText)
                            .font(.system(size: 13))
                            .foregroundStyle(.black)
                        
                    } else if isLoading {
                        
                        Text("Loading weather...")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        
                    } else {
                        
                        Text("Weather unavailable")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                } // End city and condition VStack
                
                Spacer(minLength: 0)
                
                // MARK: - Weather Icon
                
                // automatically changes based on the weather
                Image(systemName: weather?.symbolName ?? "cloud.sun.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 35))
                    .foregroundStyle(.black)
                
                // MARK: - Current Temperature
                
                if let weather {
                    
                    Text(weather.temperatureText)
                        .font(HintedFonts.adLib(27))
                        .foregroundStyle(.black)
                    
                } else {
                    
                    Text("--ºF")
                        .font(HintedFonts.adLib(27))
                        .foregroundStyle(.black)
                }
                
            } // End weather header HStack
            
            // MARK: - Divider
            
            Divider()
            
            // MARK: - Daily Weather Hint
            
            Text("Your daily weather hint")
                .font(HintedFonts.adLib(15))
                .foregroundStyle(.black)
            
            // MARK: Weather Recommendation
            
            if let weather  {
                
                // generate a hint based on live weather
                Text(weatherHint(for: weather))
                    .font(.subheadline)
                
            } else if isLoading {
                
                // display while the API request is running
                Text("Finding your weather hint...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                
                // display if the API req fails
                
                Text(
                    errorMessage ?? "Weather is unavailable."
                )
                .font(.subheadline)
                .foregroundStyle(.black)
                
                // retry button
                Button("Try Again") {
                    
                    Task {
                        await loadWeather()
                    }
                    
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(HintedColors.purple)
            }
            
            // MARK: - Open-Meteo Attribution
            
            Link(
                "Weather data by Open-Meteo",
                destination: URL(
                    string: "http://open-meteo.com/"
                )!
            )
            .font(.system(size: 10))
            .foregroundStyle(.black.opacity(0.55))
            
        } // End main VStack
        
        // MARK: - Weather Card Styling
        
        .padding(18)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(HintedColors.lightYellow)
        
        .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
        // MARK: - Load Weather Automatically
        
        .task {
            await loadWeather()
            
        }
        
    } // End body
    
    // MARK: - Generate Daily Weather Hint
    
    private func weatherHint(for weather: WeatherData) -> String {
        
        // Retrieve current temperature and weather code
        let temperature = weather.current.temperature
        let weatherCode = weather.current.weatherCode
        
        // MARK: - Rainy Weather

        // Check whether the weather code indicates rain
        let isRainy =
            (51...67).contains(weatherCode) ||
            (80...82).contains(weatherCode) ||
            (95...99).contains(weatherCode)

        // Rain and thunderstorms take priority
        if isRainy {
            return "Rain is expected! Consider a waterproof jacket and comfortable closed-toe shoes."
        }

        
        // MARK: - Cold Weather
        if temperature < 60 {
            
            return "It's chilly outside! Layer up with a sweater or jacket to stay comfortable."
        }
        
        // MARK: - Mild Weather
        
        return "It's a comfortable day! Try a casual outfit with a light layer."
    }
    
    // MARK: - Retrieve Live Weather
    
    @MainActor
    private func loadWeather() async {
        
        // Start loading
        isLoading = true
        errorMessage = nil
        
        do {
            
            // request live Fullerton weather from Open-Meteo API
            weather = try await weatherService.fetchWeather()
            
            // print success mesg in Xcode console
            print("Weather loaded successfully for Fullerton.")
            
        } catch {
            
            // clear previously  loaded weather
            weather = nil
            
            // display an error message
            errorMessage = "Could not load weather. Check your internet connection."
            
            // print error msg for debugging purposes
            print("Weather API error: \(error)")
        }
        
        // finish loading
        isLoading = false
        
    }
    
} // End of WeatherCardView
        
            
//            // MARK: - Loading State
//            
//            if isLoading {
//                
//                HStack(spacing: 10) {
//                    
//                    ProgressView()
//                    
//                    Text("Loading weather...")
//                        .foregroundStyle(.black.opacity(0.7))
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 22)
//    
//            } else if let weather {
//                
//                // MARK: - Current Temperature
//                
//                HStack(alignment: .center) {
//                    
//                    VStack(alignment: .leading, spacing: 6) {
//                        
//                        Text(weather.temperatureText)
//                            .font(.system(size: 42, weight: .bold))
//                            .foregroundStyle(.black)
//                        
//                        Text(weather.conditionText)
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundStyle(.black)
//                    }
//                    
//                    Spacer()
//                }
//                
//                Divider()
//                    .overlay(Color.black.opacity(0.2))
//                
//                // MARK: - High and Low
//                
//                HStack(spacing: 16) {
//                    
//                    Label(
//                        "High \(weather.highTemperatureText)",
//                        systemImage: "arrow.up"
//                    )
//                    
//                    Label(
//                        "Low \(weather.lowTemperatureText)",
//                        systemImage: "arrow.down"
//                    )
//                }
//                .font(.system(size: 13, weight: .medium))
//                .foregroundStyle(.black.opacity(0.8))
//                
//            } else {
//                
//                // MARK: - Error State
//                
//                Text(errorMessage ?? "Weather is unavailable.")
//                    .font(.system(size: 14))
//                    .foregroundStyle(.black)
//                
//                Button("Try Again") {
//                    
//                    Task {
//                        await loadWeather()
//                    }
//                    
//                }
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundStyle(HintedColors.purple)
//            }
//            
//            // MARK: - Weather Data Attribution
//            
//            Link(
//                "Weather data by Open-Meteo",
//                destination: URL(string: "https://open-meteo.com/")!
//            )
//            .font(.system(size: 11))
//            .foregroundStyle(.black.opacity(0.65))
//        }
//        .padding(20)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(HintedColors.lightYellow)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        
//        // Load weather when the card appears
//        .task {
//            await loadWeather()
//        }
//    }
//    
//    // MARK: - Retrieve Weather
//    
//    @MainActor
//    private func loadWeather() async {
//        
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            
//            // Request data from Open-Meteo
//            weather = try await weatherService.fetchWeather()
//            
//            print("Weather loaded successfully for Fullerton.")
//            
//        } catch {
//            
//            weather = nil
//            
//            errorMessage = "Could not load weather. Check your internet connection."
//            
//            print("Weather API error: \(error)")
//        }
//        
//        isLoading = false
//    }
//}

// MARK: - Preview
#Preview {
    WeatherCardView()
}
