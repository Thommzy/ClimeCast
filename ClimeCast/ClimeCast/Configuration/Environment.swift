//
//  Environment.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import Foundation

public enum Environment {
    
    enum Keys {
        enum Plist {
            static let baseUrl = "BASE_URL"
            static let APPID = "APP_ID"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let baseUrl: URL = {
        guard let serverBaseURLstring = Environment.infoDictionary[Keys.Plist.baseUrl] as? String else {
            fatalError("BASE_URL not set in plist for this environment")
        }
        guard let url = URL(string: serverBaseURLstring) else {
            fatalError("BASE_URL is invalid")
        }
        return url
    }()
    
    static let appID: String = {
        guard let appId = Environment.infoDictionary[Keys.Plist.APPID] as? String else {
            fatalError("APP_ID not set in plist for this environment")
        }
        
        return appId
    }()
}
