//
//  WeatherViewModel.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import UIKit
import Combine

class WeatherViewModel {
    let client: WeatherClient
    var weather = CurrentValueSubject<WeatherData?, Never>(nil)
    var weatherIcon = PassthroughSubject<UIImage, Never>()
    var noInternetError = PassthroughSubject<Void, Never>()
    var clientOrServerError = PassthroughSubject<String, Never>()
    var isLoading = PassthroughSubject<Bool, Never>()
    
    init(client: WeatherClient) {
        self.client = client
    }
    
    func fetchWeather(q: String) {
        Task {
            do {
                isLoading.send(true)
                let req = try await client.getCurrentWeather(q: q)
                if let _ = req.main {
                    weather.send(req)
                    
                    PersistenceManager.main.saveCustomModel(req, forKey: "WeatherData")
                    fetchImage(icon: req.weather.first?.icon ?? "")
                }
                isLoading.send(false)
            } catch {
                isLoading.send(false)
                DispatchQueue.main.async {[weak self] in
                    
                    guard let networkError = error as? NetworkError else {
                        self?.noInternetError.send(())
                        return
                    }
                    switch networkError {
                    case .clientError(let errors, _),.serverError(let errors) :
                        let msg = errors?["message"] as? String
                        guard let message = msg else { return }
                        self?.clientOrServerError.send(message)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func fetchImage(icon: String)  {
        if let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
            let imageLoader: ImageLoading = URLSessionImageLoader()
        
            imageLoader.loadImage(from: url) { [weak self] (image) in
                guard let image else { return }
                self?.weatherIcon.send(image)
            }
        }
    }
}
