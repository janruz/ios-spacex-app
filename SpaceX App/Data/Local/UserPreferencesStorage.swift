//
//  UserPreferencesStorage.swift
//  SpaceX App
//
//  Created by Jan Růžička on 27.09.2022.
//

import Foundation

protocol UserPreferencesStorage {
    func get(key: String) -> Int?
    func save(key: String, value: Int)
}

struct UserDefaultsPreferencesStorage: UserPreferencesStorage {
    
    //MARK: - Properties
    
    static let shared = UserDefaultsPreferencesStorage()
    
    private let defaults = UserDefaults.standard
    
    //MARK: - Functionality
    
    func get(key: String) -> Int? {
        return defaults.integer(forKey: key)
    }
    
    func save(key: String, value: Int) {
        defaults.set(value, forKey: key)
    }
}
