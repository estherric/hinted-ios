//
//  WeatherService.swift
//  Hinted
//
//  Created by esther ricardo on 11/16/26.
//

import Foundation

// MARK: - Weather API Service

struct WeatherService {
    
    // MARK: - Fullerton, California Coord
    
    private let latitude = 33.8704
    private let longtitude = -117.9242
    
    // MARK: - Fetch Current Weather
    func fetchWeather() async throws -> WeatherData {
        
        // 1. Create the Open-Meteo API URL
        guard var components = URLComponents(
            string: "https://api.open-meteo.com/v1/forecast"
        ) else  {
            throw WeatherServiceError.invalidURL
        }
        
        // 2. Specify the info we want from the API
        components.queryItems = [
            
            URLQueryItem(name: "latitude", value: String(latitude)),
            
            URLQueryItem(name: "longitude", value: String(longtitude)),
            
            URLQueryItem(name: "current", value: "temperature_2m,weather_code,is_day"),
            
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
            
            URLQueryItem(name: "temperature_unit", value: "fahrenheit"),
            
            URLQueryItem(name: "timezone", value: "America/Los_Angeles"),
            
            URLQueryItem(name: "forecast_days", value: "1"),
        ]
        
        // 3. Check that the final URL is valid
        guard let url = components.url else {
            throw WeatherServiceError.invalidURL
        }
        
        // 4. Send the HTTP req to Open-Meteo API
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 5. Check whether the request succeeded
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            
            throw WeatherServiceError.invalidResponse
        }
        
        // 6. Decode the JSON response into WeatherData
        let weather = try JSONDecoder().decode(
            WeatherData.self,
            from: data
        )
        
        // 7. Return the decoded weather info
        return weather
    }
}

// MARK: - Weather API Errors

enum WeatherServiceError: LocalizedError {
    
    case invalidURL
    case invalidResponse
    
    var errorDescription: String? {
        
        switch self {
            
        case.invalidURL:
            return "The weather URL is invalid."
            
        case.invalidResponse:
            return "The weather server returned an errror."
        }
    }
}
