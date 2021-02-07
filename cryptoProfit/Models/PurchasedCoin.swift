//
//  PurchasedCoin.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import Foundation

struct PurchasedCoin: Codable, Equatable {
    let purchasedPrice: String
    let purchasedAmount: String
    let id, symbol, name: String
    let image: String
    let latestPrice: Double // for the time that user created this record
    let lastUpdated: String // for the time that user created this record
}
