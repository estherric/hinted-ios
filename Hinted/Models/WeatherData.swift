//
//  WeatherData.swift
//  Hinted
//
//  Created by esther ricardo on 11/16/26.
//

import Foundation

struct WeatherData: Decodable {
    
    // current weather info
    let current: CurrentWeather
    
    // daily high and low temperatures
    let daily: DailyWeather
    
    // MARK: - Current Weather
    
    struct CurrentWeather : Decodable {
        
        let temperature: Double
        let weatherCode: Int
        let isDay: Int
        
        enum CodingKeys: String, CodingKey {
            
            case temperature = "temperature_2m"
            case weatherCode = "weather_code"
            case isDay = "is_day"
        }
    }
    
    // MARK: - Daily Weather
    
    struct DailyWeather: Decodable {
        
        let maximumTemperatures: [Double]
        let minimumTemperatures: [Double]
        
        enum CodingKeys: String, CodingKey {
            
            case maximumTemperatures = "temperature_2m_max"
            case minimumTemperatures = "temperature_2m_min"
        }
    }
    
    // MARK: - Temperature Formatting
    
    var temperatureText: String {
        "\(Int(current.temperature.rounded()))ºF"
    }
    
    var highTemperatureText: String {
        guard let high = daily.maximumTemperatures.first else {
            return "---"
        }
        
        return "\(Int(high.rounded()))º"
    }
    
    var lowTemperatureText: String {
        guard let low = daily.minimumTemperatures.first else {
            return "---"
        }
        
        return "\(Int(low.rounded()))º"
    }
    
    // MARK: - Weather Condition
    
    var conditionText: String {
        
        switch current.weatherCode {
            
        case 0:
            return "Clear Sky"
            
        case 1:
            return "Mainly Clear"
            
        case 2:
            return "Partly Cloudy"
            
        case 3:
            return "Cloudy"
            
        case 44, 48:
            return "Foggy"
            
        case 51...57:
            return "Drizzle"
            
        case 61...67:
            return "Rainy"
            
        case 80...82:
            return "Rain Showers"
            
        case 95...99:
            return "Thunderstorms"
            
        default:
            return "Unknown Conditions"
        }
    }
    
    // MARK: - Weather Icon
    
    var symbolName: String {
        
        switch current.weatherCode {
            
        case 0, 1:
            return current.isDay == 1
            ? "sun.max.fill"
            : "moon.stars.fill"
            
        case 2:
            return current.isDay == 1
            ? "cloud.sun.fill"
            : "cloud.moon.fill"
            
        case 3:
            return "cloud.fill"
            
        case 45, 48:
            return "cloud.fog.fill"
            
        case 51...67, 80...82:
            return "cloud.rain.fill"
            
        case 71...77, 85, 86:
            return "cloud.snow.fill"
            
        case 95...99:
            return "cloud.bold.rain.fill"
            
        default:
            return "cloud.fill"
        }
    }
}
