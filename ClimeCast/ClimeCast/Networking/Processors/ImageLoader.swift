//
//  ImageLoader.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

import UIKit

// Protocol defining the behavior of an image loader
protocol ImageLoading {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

// Concrete implementation of the ImageLoading protocol
class URLSessionImageLoader: ImageLoading {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid data or unable to create UIImage.")
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }
}
