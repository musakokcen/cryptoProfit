//
//  Endpoint.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import Foundation
import Alamofire

enum Endpoint {
    case simplePrice(query: CoinPriceParams)
    case coinsList
    case coinMarketData(query: coinMarketDataParams)
    
    var params: [String : Any] {
        switch self {
        case .simplePrice(let query):
                return [
                    "ids": query.id,
                    "vs_currencies": query.currency,
                    "include_market_cap": query.includeMarketCap,
                    "include_24hr_vol": query.includeDailyVolume,
                    "include_24hr_change": query.includeDailyChange,
                    "include_last_updated_at": query.includeLastUpdatedAt
                ]
        case .coinsList:
            return [:]
        case .coinMarketData(let query):
            return [
                "vs_currency": query.currency ?? "usd",
                "ids" : query.ids ?? " ",
                "order" : "market_cap_desc",
                "per_page": query.coinsPerPage,
                "page" : query.page
//                "price_change_percentage": "24h", // "1h", "7d" etc
            ]
        }
    }
    
    var baseUrl: String {
        switch self {
        default:
            return "https://api.coingecko.com/api/v3/"
        }
    }
    
    var path: String {
        switch self {
        case .simplePrice:
            return "simple/price?"
        case .coinsList:
            return "coins/list"
        case .coinMarketData:
            return "coins/markets"
        }
    }
    
    var url: String {
        switch self {
        default:
            return baseUrl + path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return HTTPMethod.get
        }
    }
}

struct coinMarketDataParams {
    let currency: String?
    let ids: String?
    let coinsPerPage: Int
    let page: Int
    let priceChangeRange: String?
}

struct CoinPriceParams {
    let id: String
    let currency: String
    var includeMarketCap: String {
        return "true"
    }
    var includeDailyVolume: String {
        return "true"
    }
    var includeDailyChange: String {
        return "true"
    }
    
    var includeLastUpdatedAt: String {
        return "true"
    }
}
