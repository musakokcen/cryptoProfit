//
//  Endpoint.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import Foundation
import Alamofire

enum Endpoint {
    case simplePrice(info: CoinPriceParams)
    case coinsList
    
    var params: [String : Any] {
        switch self {
        case .simplePrice(let info):
                return [
                    "ids": info.id,
                    "vs_currencies": info.currency,
                    "include_market_cap": info.includeMarketCap,
                    "include_24hr_vol": info.includeDailyVolume,
                    "include_24hr_change": info.includeDailyChange,
                    "include_last_updated_at": info.includeLastUpdatedAt
                ]
        case .coinsList:
            return [:]
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
            return "/coins/list"
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
