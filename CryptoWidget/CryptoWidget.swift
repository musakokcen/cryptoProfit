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

    @State private var investmentList: [PurchasedCoin] =  UserDefaultsConfig.purchasedCryptoCoins ?? []

//    @State var investmentCoinInfo: PurchasedCoin? = nil
    var body: some View {
        Text("widget\(entry.coinInfo?.first?.name ?? "no result")")
//        VStack {
//            HStack {
//                Text("Crypto Profit")
//                    .padding()
//                Spacer()
//            }
//            .font(Font.custom("Quantico-Regular", size: 12))
////            if let coins = entry.coins {
//            ForEach(entry.coins ?? [], id: \.id) { coin in
////                    InvestedCoinList(coin: coin)
//                InvestedCoinList(coin: PurchasedCoin(purchasedPrice: "1", purchasedAmount: "1", id: coin.id, symbol: coin.symbol, name: coin.name, image: coin.image, latestPrice: coin.currentPrice, lastUpdated: coin.lastUpdated))
//                }
////            } else {
////                Spacer()
////                Text("Loading...\(entry.coins?.first?.name ?? "coin name")")
////                    .font(Font.custom("Quantico-Regular", size: 12))
////            }
//            Spacer()
//        }
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: CryptoCoinEntry(date: Date(), coinInfo: nil))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


