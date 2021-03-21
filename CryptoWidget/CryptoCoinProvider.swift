//
//  CryptoCoinProvider.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 21.03.2021.
//

import Foundation
import WidgetKit

struct CryptoCoinEntry: TimelineEntry {
    public let date: Date
    public let coinInfo: [CoinMarketData]?
    public var isPlaceholder = false
}

extension CryptoCoinEntry {

    static var stub: CryptoCoinEntry {
        CryptoCoinEntry(date: Date(), coinInfo: nil)
    }
    
    static var placeholder: CryptoCoinEntry {
        CryptoCoinEntry(date: Date(), coinInfo: nil, isPlaceholder: true)
        
    }
}

struct CryptoCoinTimelineProvider: TimelineProvider {
    
    typealias Entry = CryptoCoinEntry
    let service = NetworkManager.shared
 
    func placeholder(in context: Context) -> CryptoCoinEntry {
        CryptoCoinEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CryptoCoinEntry) -> Void) {
        if context.isPreview {
            completion(CryptoCoinEntry.placeholder)
        } else {
            fetchTotalGlobalCaseStats { (result) in
                switch result {
                case .success(let entry):
                    completion(entry)
                case .failure(_):
                    completion(CryptoCoinEntry.placeholder)
                }
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CryptoCoinEntry>) -> Void) {
        fetchTotalGlobalCaseStats { (result) in
            switch result {
            case .success(let entry):
                // Refresh every 10 mins
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 10)))
                completion(timeline)
            case .failure(_):
                // Refresh after 1 min
                let entry = CryptoCoinEntry.placeholder
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
                completion(timeline)
            }
        }
    }
    
    private func fetchTotalGlobalCaseStats(completion: @escaping (Result<CryptoCoinEntry, Error>) -> ()) {
        service.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: "usd", ids: nil, coinsPerPage: 50, page: 1, priceChangeRange: nil))) { (result) in
            switch result {
            case .success(let data):
                let sortedData = data.sorted{$0.marketCap > $1.marketCap }
                let currentDate = Date()
                
                completion(.success(CryptoCoinEntry(date: currentDate, coinInfo: sortedData)))
                print("network call is successfull: ")
                
            case .failure(let err):
                print("network call is unsuccesfull: ", err)
                completion(.failure(err))
            }
        }
    }
}
