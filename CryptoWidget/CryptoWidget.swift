//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Musa Kokcen on 20.02.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @State private var fetchedCoins: [CoinMarketData]?
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), coins: fetchedCoins)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), coins: fetchedCoins)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        WidgetCenter.shared.reloadAllTimelines()

            NetworkManager.shared.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: "usd", ids: nil, coinsPerPage: 50, page: 1, priceChangeRange: nil))) { (result) in
                switch result {
                case .success(let data):
                    let sortedData = data.sorted{$0.marketCap > $1.marketCap }
                    fetchedCoins = sortedData
                    let currentDate = Date()
                    let entries = [
                        SimpleEntry(date: currentDate, coins: fetchedCoins)
                                ]
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeline = Timeline(entries: entries, policy: .after(refreshDate))
                        completion(timeline)
                    print("network call is successfull: ")
                    WidgetCenter.shared.reloadAllTimelines()

                case .failure(let err):
                    print("network call is unsuccesfull: ", err)
                }
            }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let coins: [CoinMarketData]?
}

struct CryptoWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
        
    @State private var investmentList: [PurchasedCoin] =  UserDefaultsConfig.purchasedCryptoCoins ?? []
    
    @State var investmentCoinInfo: PurchasedCoin? = nil
    var body: some View {
        VStack {
            HStack {
                Text("Crypto Profit")
                    .padding()
                Spacer()
            }
            .font(Font.custom("Quantico-Regular", size: 12))
//            if let coins = entry.coins {
            ForEach(entry.coins ?? [], id: \.id) { coin in
//                    InvestedCoinList(coin: coin)
                InvestedCoinList(coin: PurchasedCoin(purchasedPrice: "1", purchasedAmount: "1", id: coin.id, symbol: coin.symbol, name: coin.name, image: coin.image, latestPrice: coin.currentPrice, lastUpdated: coin.lastUpdated))
                }
//            } else {
//                Spacer()
//                Text("Loading...\(entry.coins?.first?.name ?? "coin name")")
//                    .font(Font.custom("Quantico-Regular", size: 12))
//            }
            Spacer()
        }
    }
}

@main
struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CryptoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date(), coins: nil))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


