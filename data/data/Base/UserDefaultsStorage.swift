//
//  UserDefaultsStorage.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation

protocol UserDefaultsStorageProtocol {
    func cache<T: Encodable>(key: UserDefaultsKey, data: T)
    func cache(key: UserDefaultsKey, value: String)
    func cache(key: UserDefaultsKey, value: Int)
    func getCached<T: Decodable>(key: UserDefaultsKey) -> T?
    func getCachedString(key: UserDefaultsKey) -> String?
    func getCachedInt(key: UserDefaultsKey) -> Int?
    func getCachedDouble(key: UserDefaultsKey) -> Double?
    func removeCachedValue(key: UserDefaultsKey)
}

open class UserDefaultsStorage: UserDefaultsStorageProtocol {
    // MARK: - Variables
    private let userDefaults: UserDefaults
    let logger: Logger
    
    // MARK: - Constructor
    init(logger: Logger) {
        self.userDefaults = UserDefaults.standard
        self.logger = logger
    }
    
    // MARK: - Functions
    func cache<T: Encodable>(key: UserDefaultsKey, data: T) {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: key.rawValue)
        } else {
            logger.logDebug("Not saved \(T.self)")
        }
    }
    
    func cache(key: UserDefaultsKey, value: String) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func cache(key: UserDefaultsKey, value: Int) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getCached<T: Decodable>(key: UserDefaultsKey) -> T? {
        if let data = userDefaults.object(forKey: key.rawValue) as? Data {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        logger.logDebug("Couldn't get cached value of type: \(T.self)")
        return nil
    }
    
    func getCachedString(key: UserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func getCachedInt(key: UserDefaultsKey) -> Int? {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    func getCachedDouble(key: UserDefaultsKey) -> Double? {
        return userDefaults.double(forKey: key.rawValue)
    }
    
    func removeCachedValue(key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

enum UserDefaultsKey: String {
    case language
    case token
    case checkToken
    case refreshToken
}
