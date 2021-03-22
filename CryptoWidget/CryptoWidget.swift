//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Musa Kokcen on 20.02.2021.
//

import WidgetKit
import SwiftUI

@main
struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CryptoCoinTimelineProvider(), content: { entry in
            CryptoWidgetEntryView(entry: entry)
        })
        
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

struct CryptoWidgetEntryView : View {
    var entry: CryptoCoinEntry
    @Environment(\.widgetFamily) var family

    @State private var investmentList: [PurchasedCoin] =  UserDefaultsConfig.purchasedCryptoCoins ?? [] {
        didSet {
            print("investment list", investmentList.count)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Crypto Profit")
                    .padding()
                Spacer()
            }
            .font(Font.custom("Quantico-Regular", size: 12))
//            if let coins = entry.coins {
            ForEach(investmentList, id: \.id) { coin in
//                    InvestedCoinList(coin: coin)
                if let purchasedCoin = getPurchasedCoin(for: coin) {
//                    InvestedCoinList(coin: purchasedCoin)
                    InvestedCoinList(coin: PurchasedCoin(purchasedPrice: coin.purchasedPrice, purchasedAmount: coin.purchasedAmount, id: coin.id, symbol: coin.symbol, name: coin.name, image: coin.image, latestPrice: purchasedCoin.currentPrice, lastUpdated: purchasedCoin.lastUpdated))
                } else {
//                    Text("data for the invested coin could not be loaded")
                    InvestedCoinList(coin: coin)
                }
                }
               
//            } else {
//                Spacer()
//                Text("Loading...\(entry.coins?.first?.name ?? "coin name")")
//                    .font(Font.custom("Quantico-Regular", size: 12))
//            }
            Spacer()
        }
    }
    
    private func getPurchasedCoin(for coin: PurchasedCoin) -> CoinMarketData? {
        if let fetchedCoin = entry.coinInfo?.first(where: {$0.symbol == coin.symbol}) {
            return fetchedCoin
        }
        return nil
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: CryptoCoinEntry(date: Date(), coinInfo: nil))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


