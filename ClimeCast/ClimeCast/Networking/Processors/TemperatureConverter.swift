//
//  TemperatureConverter.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

import Foundation

// Protocol defining the temperature converter behavior
protocol TemperatureConverter {
    func convertToCelsius(from temperature: Double) -> Double
    func convertToFahrenheit(from temperature: Double) -> Double
}

// Class implementing the temperature converter
class StandardTemperatureConverter: TemperatureConverter {
    func convertToCelsius(from temperature: Double) -> Double {
        return temperature - 273.15
        
    }
    
    func convertToFahrenheit(from temperature: Double) -> Double {
        return (temperature - 273.15) * (9/5) + 32
    }
}
