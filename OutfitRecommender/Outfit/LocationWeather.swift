//
//  LocationWeather.swift
//  Armario
//
//  Created by Fernando Villalba  on 7/5/22.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

struct Location: Codable{
    
    let key: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case name = "LocalizedName"
    }
}

struct LocationWeather: Codable{
    
    let dailyForecast: [DailyForecasts]
    
    enum CodingKeys: String, CodingKey {
        case dailyForecast = "DailyForecasts"
    }
}

struct DailyForecasts: Codable{
    
    let fecha: String
    let temperature: Temperature
    let day: DayNight
    let night: DayNight
    
    enum CodingKeys: String, CodingKey {
        case fecha = "EpochDate"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let epochComoFecha = try? container.decode(Int.self, forKey: .fecha ){
            fecha = Date(timeIntervalSince1970: TimeInterval(epochComoFecha)).getFormattedDate(format: "dd-MM")
        }
        else {
            fecha = Date().description
        }
        
        temperature = try container.decode(Temperature.self, forKey: .temperature)
        day = try container.decode(DayNight.self, forKey: .day)
        night = try container.decode(DayNight.self, forKey: .night)
    }
}

struct DayNight: Codable{

    let icon: Int
    let phrase: String
    let hasPrecipitation: Bool
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case phrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
    }
}

struct Temperature: Codable{
    
    let max: TemperatureMaxMin
    let min: TemperatureMaxMin
    
    enum CodingKeys: String, CodingKey {
        case max = "Maximum"
        case min = "Minimum"
    }
}

struct TemperatureMaxMin: Codable{
    
    let value: Double
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
    }
}

