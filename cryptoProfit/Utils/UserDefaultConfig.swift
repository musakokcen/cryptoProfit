//
//  UserDefaultConfig.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.

import Foundation

struct UserDefaultsConfig {
    @UserDefaultProperty(key: "purchasedCryptoCoins", defaultValue: nil)
    static var purchasedCryptoCoins: [PurchasedCoin]?
}

@propertyWrapper
struct UserDefaultProperty<Value: Codable> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults =  UserDefaults(suiteName: "group.musakokcen.cryptoProfit")!
    
    struct Wrapper<Value>: Codable where Value: Codable {
        let wrapped: Value
    }
    
    var wrappedValue: Value {
        get {
            guard let data = storage.object(forKey: key) as? Data else {
                return defaultValue
            }
            
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
            
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            storage.set(data, forKey: key)
            
        }
    }
}

extension UserDefaultProperty where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults =  UserDefaults(suiteName: "group.musakokcen.cryptoProfit")!) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

