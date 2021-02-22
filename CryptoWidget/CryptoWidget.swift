//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Musa Kokcen on 20.02.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CryptoWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var defCoin: CoinMarketData = CoinMarketData(id: "btc", symbol: "btc2", name: "bitcoin", image: "noimage", currentPrice: 38876.322, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 11, totalVolume: 11, high24H: 11, low24H: 11, priceChange24H: 3569.39, priceChangePercentage24H: 11, marketCapChange24H: 222, marketCapChangePercentage24H: 11, circulatingSupply: 2, totalSupply: 22, maxSupply: 11, ath: 33, athChangePercentage: 2, athDate: "we", atl: 33, atlChangePercentage: 2, atlDate: "we", roi: nil, lastUpdated: "we")

    @State private var coinList: [CoinMarketData] = [CoinMarketData(id: "btc", symbol: "btc2", name: "bitcoin", image: "noimage", currentPrice: 38876.322, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 11, totalVolume: 11, high24H: 11, low24H: 11, priceChange24H: 3569.39, priceChangePercentage24H: 11, marketCapChange24H: 222, marketCapChangePercentage24H: 11, circulatingSupply: 2, totalSupply: 22, maxSupply: 11, ath: 33, athChangePercentage: 2, athDate: "we", atl: 33, atlChangePercentage: 2, atlDate: "we", roi: nil, lastUpdated: "we"), CoinMarketData(id: "btc", symbol: "btc2", name: "bitcoin", image: "noimage", currentPrice: 38876.322, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 11, totalVolume: 11, high24H: 11, low24H: 11, priceChange24H: 3569.39, priceChangePercentage24H: 11, marketCapChange24H: 222, marketCapChangePercentage24H: 11, circulatingSupply: 2, totalSupply: 22, maxSupply: 11, ath: 33, athChangePercentage: 2, athDate: "we", atl: 33, atlChangePercentage: 2, atlDate: "we", roi: nil, lastUpdated: "we"), CoinMarketData(id: "btc", symbol: "btc2", name: "bitcoin", image: "noimage", currentPrice: 38876.322, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 11, totalVolume: 11, high24H: 11, low24H: 11, priceChange24H: 3569.39, priceChangePercentage24H: 11, marketCapChange24H: 222, marketCapChangePercentage24H: 11, circulatingSupply: 2, totalSupply: 22, maxSupply: 11, ath: 33, athChangePercentage: 2, athDate: "we", atl: 33, atlChangePercentage: 2, atlDate: "we", roi: nil, lastUpdated: "we")]
    
    @State private var investmentList: [PurchasedCoin] = [PurchasedCoin(purchasedPrice: "875.78", purchasedAmount: "3", id: "eth", symbol: "eth", name: "ethereum", image: "", latestPrice: 1955.45, lastUpdated: ""), PurchasedCoin(purchasedPrice: "875.78", purchasedAmount: "3", id: "eth", symbol: "eth", name: "ethereum", image: "", latestPrice: 1955.45, lastUpdated: ""), PurchasedCoin(purchasedPrice: "875.78", purchasedAmount: "3", id: "eth", symbol: "eth", name: "ethereum", image: "", latestPrice: 1955.45, lastUpdated: "")]
    
    @State var coinIcon = Image(systemName: "creditcard.circle")
    @State var investmentCoinInfo: PurchasedCoin? = nil
    
    @State var profitValue: Double = 0
    @State var profitPercentage: Double = 0
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Crypto Profit")
                    .padding()
                Spacer()
            }
            .font(Font.custom("Quantico-Regular", size: 12))
            
//            VStack(alignment: .center, spacing: 4, content: {
//                HStack {
//                    Spacer()
//                        .frame(width: 90, height: .none, alignment: .trailing)
//                    Text("Revenue")
//                    Spacer()
//                    Text("Current")
//                    Spacer()
//                        .frame(width: 20, height: .none, alignment: .trailing)
//                }
//                Divider()
//                 .frame(height: 1)
//                 .padding(.horizontal, 30)
//                    .background(Color.white)
//            })
            
            ForEach(investmentList, id: \.id) { coin in
                HStack {
                    if family != .systemSmall {
                        coinIcon
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .leading)
                    }
                    Text(coin.symbol)
                        .font(Font.custom("Quantico-Bold", size: 12))
                        .textCase(.uppercase)
                        .frame(width: .none, height: .none, alignment: .leading)
                    Text("458.23$")
                        .frame(width: .none, height: .none, alignment: .leading)
    //                Text("\(profitValue, specifier: "%.2f")$")
                    Image(systemName: profitValue > 0 ? "arrow.up.square.fill" : "arrow.down.square.fill")
                        .foregroundColor(profitValue > 0 ?  .green : .red)
                        .font(.system(size: 20, weight: .thin))
                    if family != .systemSmall {
                    Text("%32.98")
    //                Text("%\(profitPercentage, specifier: "%.2f")")
                    Text("2257.23$")
                    }
                }
                .font(Font.custom("Quantico-Regular", size: 12))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 8)
                .frame(width: .none, height: 60, alignment: .leading)
                .onAppear(perform: {
    //                fetchIcon()
                    if let investmentCoinInfo = UserDefaultsConfig.purchasedCryptoCoins?.first(where: {$0.id == coin.id}), let purchasedPrice = Double(investmentCoinInfo.purchasedPrice), let amount = Double(investmentCoinInfo.purchasedAmount) {
                        profitValue =  (defCoin.currentPrice - purchasedPrice) * amount
                        profitPercentage = (profitValue / (purchasedPrice * amount)) * 100
                    }
                })
            }
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
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
