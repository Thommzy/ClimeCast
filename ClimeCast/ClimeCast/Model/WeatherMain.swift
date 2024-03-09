//
//  WeatherMain.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

struct WeatherMain: Codable {
    let temp: Double?

    private enum CodingKeys: String, CodingKey {
        case temp
    }
    
    // Temperature converter instance using the StandardTemperatureConverter
    private let temperatureConverter: TemperatureConverter = StandardTemperatureConverter()

    // Computed property for converted temperature to Celsius as a formatted string
    var celsius: String? {
        guard let temperature = temp else { return nil }
        let celsiusValue = temperatureConverter.convertToCelsius(from: temperature)
        return String(format: "%.0f°C", celsiusValue)
    }

    // Computed property for converted temperature to Fahrenheit as a formatted string
    var fahrenheit: String? {
        guard let temperature = temp else { return nil }
        let fahrenheitValue = temperatureConverter.convertToFahrenheit(from: temperature)
        return String(format: "%.0f°F", fahrenheitValue)
    }
}


