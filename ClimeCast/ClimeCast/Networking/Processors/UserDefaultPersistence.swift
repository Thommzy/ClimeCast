//
//  UserDefaultPersistence.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

import Foundation

// Protocol defining the behavior for encoding and decoding
protocol CodablePersistence {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
}

// Concrete implementation of the CodablePersistence protocol
final class UserDefaultsCodablePersistence: CodablePersistence {
    private let prefix = "com.tim.persistenceManager"

    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: "\(prefix).\(key)")
            UserDefaults.standard.synchronize()
        } catch {
            print("Error encoding value: \(error.localizedDescription)")
        }
    }

    func load<T: Codable>(forKey key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: "\(prefix).\(key)") {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding value: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
