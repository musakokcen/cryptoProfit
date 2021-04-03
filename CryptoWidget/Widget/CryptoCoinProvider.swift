//
//  CryptoCoinProvider.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 21.03.2021.
//

import Foundation
import WidgetKit
import Kingfisher

struct CryptoCoinEntry: TimelineEntry {
    public let date: Date
    public let coinInfo: [WidgetCoinData]?
}

extension CryptoCoinEntry {

    static var stub: CryptoCoinEntry {
        CryptoCoinEntry(date: Date(), coinInfo: nil)
    }
    
    static var placeholder: CryptoCoinEntry {
        CryptoCoinEntry(date: Date(), coinInfo: nil)
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
        service.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: Currency.USD.name.lowercased().replacingOccurrences(of: " ", with: ""), ids: nil, coinsPerPage: 50, page: 1, priceChangeRange: nil))) { (result) in
            switch result {
            case .success(let data):
                let sortedData = data.sorted{$0.marketCap > $1.marketCap }
                fetchIcon(data: sortedData) { (coinsWithIcons) in
                    let currentDate = Date()
                    
                    completion(.success(CryptoCoinEntry(date: currentDate, coinInfo: coinsWithIcons)))
                    print("network call is successfull: ")
                }

                
            case .failure(let err):
                print("network call is unsuccesfull: ", err)
                completion(.failure(err))
            }
        }
    }
    
    private func fetchIcon(data: [CoinMarketData], completion: @escaping ([WidgetCoinData]) -> ()) {
        var finalData: [WidgetCoinData] = []
        for index in 0..<data.count{
            let resource = ImageResource(downloadURL: URL(string: data[index].image)!)
            KingfisherManager.shared.retrieveImage(with: resource) { (result) in
                switch result {
                case .success(let imageData):
                    finalData.append(WidgetCoinData(coin: data[index], image: imageData.image))
                    if index == data.count - 1 {
                        completion(finalData)
                    }
                case .failure(_):
                    finalData.append(WidgetCoinData(coin: data[index], image: UIImage(systemName: "creditcard.circle")!))
                    if index == data.count - 1 {
                        completion(finalData)
                    }
                }
            }
        }
    }
}
