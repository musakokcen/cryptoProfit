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
    @State private var investmentList: [PurchasedCoin] =  UserDefaultsConfig.purchasedCryptoCoins.map({ (coins) -> [PurchasedCoin] in
        if coins.count <= 4 {
            return coins
        } else {
            var fourCoins = coins
            while fourCoins.count > 4  {
                fourCoins.removeLast()
            }
            return fourCoins
        }
    }) ?? []
    
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
                            InvestedCoinList(coin: PurchasedCoin(purchasedPrice: coin.purchasedPrice, purchasedAmount: coin.purchasedAmount, id: coin.id, symbol: coin.symbol, name: coin.name, image: coin.image, latestPrice: purchasedCoin.coin.currentPrice, lastUpdated: purchasedCoin.coin.lastUpdated), profit: profit, profitPercentage: perc, coinIcon: purchasedCoin.image)
                        }
                    } else {
                        InvestedCoinList(coin: coin, profit: 0, profitPercentage: 0, coinIcon: nil)
                    }

            }
            Spacer()
        }
    }
    
    private func getPurchasedCoin(for coin: PurchasedCoin) -> WidgetCoinData? {
        if let fetchedCoin = entry.coinInfo?.first(where: {$0.coin.symbol == coin.symbol}) {
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


