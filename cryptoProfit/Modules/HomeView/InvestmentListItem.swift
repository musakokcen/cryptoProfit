//
//  InvestmentListItem.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI
import Kingfisher

struct InvestmentListItem: View {
    var coin: CoinMarketData
    
    @State var coinIcon = Image(systemName: "creditcard.circle")
    @State var investmentCoinInfo: PurchasedCoin? = nil
    
    @State var profitValue: Double = 0
    @State var profitPercentage: Double = 0
    
    var body: some View {
        NavigationLink(destination: CoinView(coin: coin, coinIcon: coinIcon)) {
            HStack {
                coinIcon
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .leading)
                Text(coin.symbol)
                    .font(Font.headline.weight(.bold))
                    .textCase(.uppercase)
                    .frame(width: 40, height: 30, alignment: .leading)
                Text(coin.name)
                    .font(Font.headline.weight(.medium))
                    .textCase(.none)
                    .frame(width: 80, height: 30, alignment: .leading)
                Text("\(profitValue, specifier: "%.2f")$")
                    .frame(width: 80, height: 30, alignment: .leading)
                Image(systemName: profitValue > 0 ? "arrow.up.square.fill" : "arrow.down.square.fill")
                    .foregroundColor(profitValue > 0 ?  .green : .red)
                    .font(.system(size: 30.0, weight: .thin))
                Text("%\(profitPercentage, specifier: "%.2f")")
                Spacer()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.4)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 5)
            .frame(width: .none, height: 60, alignment: .leading)
            .onAppear(perform: {
                fetchIcon()
                if let investmentCoinInfo = UserDefaultsConfig.purchasedCryptoCoins?.first(where: {$0.id == coin.id}), let purchasedPrice = Double(investmentCoinInfo.purchasedPrice), let amount = Double(investmentCoinInfo.purchasedAmount) {
                    profitValue =  (coin.currentPrice - purchasedPrice) * amount
                    profitPercentage = (profitValue / (purchasedPrice * amount)) * 100
                }
            })
        }
    }
    
    private func fetchIcon() {
        let resource = ImageResource(downloadURL: URL(string: coin.image)!)
        KingfisherManager.shared.retrieveImage(with: resource) { (result) in
            switch result {
            case .success(let data):
                coinIcon = Image(uiImage: data.image)
            case .failure(let err):
                print(err)
            }
        }
    }
}

struct InvestmentListItem_Previews: PreviewProvider {
    static var previews: some View {
        let coin = CoinMarketData(
            id: "bitcoin",
            symbol : "btc",
            name : "Bitcoin",
            image : "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            currentPrice : 33904.0456,
            marketCap : 630362181507,
            marketCapRank : 1,
            fullyDilutedValuation: 0,
            totalVolume: 0,
            high24H: 0,
            low24H: 0,
            priceChange24H: 0,
            priceChangePercentage24H: 3.0555,
            marketCapChange24H: 0,
            marketCapChangePercentage24H: 0,
            circulatingSupply: 0,
            totalSupply: 0,
            maxSupply: 0,
            ath: 0,
            athChangePercentage: 0,
            athDate: "string",
            atl: 0,
            atlChangePercentage: 0,
            atlDate: "String",
            roi: nil,
            lastUpdated: "String")

        InvestmentListItem(coin: coin, coinIcon: Image(systemName: "creditcard.circle"))
            .previewLayout(.sizeThatFits)
    }
}
