//
//  PersistenceManager.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

final class PersistenceManager {
    static var main = PersistenceManager()
    
    // Inject CodablePersistence dependency
    private var codablePersistence: CodablePersistence
    
    init(codablePersistence: CodablePersistence = UserDefaultsCodablePersistence()) {
        self.codablePersistence = codablePersistence
    }
    
    var isFaved: Bool {
        get {
            UserDefaults.standard.value(forKey: "isFaved") as? Bool ?? false
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "isFaved")
            UserDefaults.standard.synchronize()
        }
    }
    
    // New methods to save and load custom models
    func saveCustomModel<T: Codable>(_ model: T, forKey key: String) {
        codablePersistence.save(model, forKey: key)
    }
    
    func loadCustomModel<T: Codable>(forKey key: String) -> T? {
        return codablePersistence.load(forKey: key)
    }
}
