//
//  WaetherData.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
    let base: String?
    let main: WeatherMain?
    let sys: Country?
    let name: String?
    let cod: Int?
    let message: String?
}
