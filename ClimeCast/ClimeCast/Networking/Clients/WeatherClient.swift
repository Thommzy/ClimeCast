//
//  WeatherClient.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

protocol WeatherClientProtocol {
    func getCurrentWeather(q: String) async throws -> WeatherData
}

class WeatherClient: WeatherClientProtocol, NetworkUtil {
    func getCurrentWeather(q: String) async throws -> WeatherData {
        let url = baseUrl
        
        return try await self.request(
            url: url, 
            method: .get,
            queryParam: ["q": q, "appid": appID],
            expecting: WeatherData.self
        )
    }
}
