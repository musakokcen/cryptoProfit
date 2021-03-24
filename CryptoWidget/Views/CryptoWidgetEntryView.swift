//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Musa Kokcen on 20.02.2021.
//

import WidgetKit
import SwiftUI

struct CryptoWidgetConstants {
    static let title: String = Localizable.cryptoProfit
    static let font: Font = Font.custom("Quantico-Regular", size: 12)
}

struct CryptoWidgetEntryView : View {
    
    var entry: CryptoCoinEntry
    @Environment(\.widgetFamily) var family
    @State private var investmentList: [PurchasedCoin] =  UserDefaultsConfig.purchasedCryptoCoins ?? []
    
    var body: some View {
        VStack {
            HStack {
                Text(CryptoWidgetConstants.title)
                    .padding()
                Spacer()
            }
            .font(CryptoWidgetConstants.font)
            ForEach(investmentList, id: \.id) { coin in
                if let purchasedCoin = getPurchasedCoin(for: coin) {
                    if let purchasedPrice = Double(coin.purchasedPrice), let amount = Double(coin.purchasedAmount) {
                        let profit = (coin.latestPrice - purchasedPrice) * amount
                        let perc = ((coin.latestPrice / purchasedPrice) - 1) * 100
                        InvestedCoinList(coin: PurchasedCoin(purchasedPrice: coin.purchasedPrice, purchasedAmount: coin.purchasedAmount, id: coin.id, symbol: coin.symbol, name: coin.name, image: coin.image, latestPrice: purchasedCoin.currentPrice, lastUpdated: purchasedCoin.lastUpdated), profit: profit, profitPercentage: perc)
                    }
                } else {
                    InvestedCoinList(coin: coin, profit: 0, profitPercentage: 0)
                }
            }
            Spacer()
        }
    }
    
    private func getPurchasedCoin(for coin: PurchasedCoin) -> CoinMarketData? {
        if let fetchedCoin = entry.coinInfo?.first(where: {$0.symbol == coin.symbol}) {
            return fetchedCoin
        }
        print("could not fetch coin")
        return nil
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: CryptoCoinEntry(date: Date(), coinInfo: nil))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


