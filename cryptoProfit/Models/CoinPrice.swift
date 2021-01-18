//
//  CoinPrice.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import Foundation

let chosenCurrency = "usd"
let choosenCrypto = "bitcoin"

struct CoinPrice: Codable {
    let coin: Coin
    
    private static var coinKey: String {
        return choosenCrypto
    }
    
    private struct CoinCodingKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder:Decoder) throws {
        let priceValue = try decoder.container(keyedBy: CoinCodingKey.self)
        let coinKey = CoinCodingKey(stringValue: CoinPrice.coinKey)!
        coin = try priceValue.decode(Coin.self, forKey: coinKey)
    }
}

struct Coin: Codable {
    let price: Int
    let marketCap, dailyVol, dailyChange: Double?
    let lastUpdatedAt: Int?
    
    private static var priceKey: String {
        return chosenCurrency
    }
    private static var marketCapKey: String {
        return "\(chosenCurrency)_market_cap"
    }
    private static var dailyVolKey: String {
        return "\(chosenCurrency)_24h_vol"
    }
    private static var dailyChangeKey: String {
        return "\(chosenCurrency)_24h_change"
    }

    private struct CurrencyCodingKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    enum SimpleCodingKeys: String, CodingKey {
        case lastUpdatedAt = "last_updated_at"
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: SimpleCodingKeys.self)
        lastUpdatedAt = try values.decode(Int.self, forKey: .lastUpdatedAt)

        let baseKeyValue = try decoder.container(keyedBy: CurrencyCodingKey.self)
        
        let coinKey = CurrencyCodingKey(stringValue: Coin.priceKey)!
        price = try baseKeyValue.decode(Int.self, forKey: coinKey)
        let marketCapKey = CurrencyCodingKey(stringValue: Coin.marketCapKey)!
        marketCap = try baseKeyValue.decode(Double.self, forKey: marketCapKey)
        let dailyVolKey = CurrencyCodingKey(stringValue: Coin.dailyVolKey)!
        dailyVol = try baseKeyValue.decode(Double.self, forKey: dailyVolKey)
        let dailyChangeKey = CurrencyCodingKey(stringValue: Coin.dailyChangeKey)!
        dailyChange = try baseKeyValue.decode(Double.self, forKey: dailyChangeKey)
    }
}
