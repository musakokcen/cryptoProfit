//
//  InvestedCoinList.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 2.03.2021.
//

import SwiftUI
import WidgetKit

struct InvestedCoinListConstants {
    static let coinIcon: UIImage = UIImage(systemName: "creditcard.circle")!
    static let coinIconWidth: CGFloat = 30
    static let coinSymbolFont: Font = Font.custom("Quantico-Bold", size: 12)
    static let profitFont: Font = .system(size: 20, weight: .thin)
    static let arrowUp: String = "arrow.up.square.fill"
    static let arrowDown: String = "arrow.down.square.fill"
    
    static let bodyFont: Font = Font.custom("Quantico-Regular", size: 12)
    static let bodyLineLimit: Int = 1
    static let bodyMinimumScaleFactor: CGFloat = 0.4
    static let bodyVerticalPadding: CGFloat = 10
    static let bodyHorizontalPadding: CGFloat = 8
    static let bodyHeight: CGFloat = 60
}

struct InvestedCoinList: View {
    var coin: PurchasedCoin
    var profitValue: Double
    var profitPercentage: Double
    var coinIcon: Image
    
    
    init(coin: PurchasedCoin, profit: Double, profitPercentage: Double, coinIcon: UIImage?) {
        self.coin = coin
        self.profitValue = profit
        self.profitPercentage = profitPercentage
        self.coinIcon = Image(uiImage: coinIcon ?? InvestedCoinListConstants.coinIcon)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                coinIcon
                    .resizable()
                    .frame(width: geo.size.width / 12, height: geo.size.width / 12, alignment: .leading)
                Text(coin.symbol.uppercased())
                    .font(InvestedCoinListConstants.coinSymbolFont)
                    .frame(width: geo.size.width / 8, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
                Text("\(coin.latestPrice, specifier: "%.3f")") // "\(profitValue, specifier: "%.2f")$")
                    .frame(width: geo.size.width / 6, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
                Image(systemName: profitValue > 0 ? InvestedCoinListConstants.arrowUp : InvestedCoinListConstants.arrowDown)
                    .foregroundColor(profitValue > 0 ?  .green : .red)
                    .font(InvestedCoinListConstants.profitFont)
                    .frame(width: geo.size.width / 8, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
                Text("%\(profitPercentage, specifier: "%.2f")")
                    .frame(width: geo.size.width / 6, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
                Text("\(profitValue, specifier: "%.2f")$")
                    .frame(width: geo.size.width / 6, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
            }
            .font(InvestedCoinListConstants.bodyFont)
            .lineLimit(InvestedCoinListConstants.bodyLineLimit)
            .minimumScaleFactor(InvestedCoinListConstants.bodyMinimumScaleFactor)
            .padding([.top, .bottom], InvestedCoinListConstants.bodyVerticalPadding)
            .padding([.leading, .trailing], InvestedCoinListConstants.bodyHorizontalPadding)
            .frame(width: .none, height: InvestedCoinListConstants.bodyHeight, alignment: .leading)
        }
    }
}
