//
//  InvestedCoinList.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 2.03.2021.
//

import SwiftUI
import WidgetKit

struct InvestedCoinListConstants {
    static let coinIcon: Image = Image(systemName: "creditcard.circle")
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
    
    @State var coinIcon = InvestedCoinListConstants.coinIcon
    
    
    init(coin: PurchasedCoin, profit: Double, profitPercentage: Double) {
        self.coin = coin
        self.profitValue = profit
        self.profitPercentage = profitPercentage
    }
    
    var body: some View {
        HStack {
            coinIcon
                .resizable()
                .frame(width: InvestedCoinListConstants.coinIconWidth, height: InvestedCoinListConstants.coinIconWidth, alignment: .leading)
            
            Text(coin.symbol)
                .font(InvestedCoinListConstants.coinSymbolFont)
                .textCase(.uppercase)
                .frame(width: .none, height: .none, alignment: .leading)
            Text("\(coin.latestPrice, specifier: "%.3f")") // "\(profitValue, specifier: "%.2f")$")
                .frame(width: .none, height: .none, alignment: .leading)
            Image(systemName: profitValue > 0 ? InvestedCoinListConstants.arrowUp : InvestedCoinListConstants.arrowDown)
                .foregroundColor(profitValue > 0 ?  .green : .red)
                .font(InvestedCoinListConstants.profitFont)
            
            Text("%\(profitPercentage, specifier: "%.2f")")
                .frame(width: .none, height: .none, alignment: .leading)
            Text("\(profitValue, specifier: "%.2f")$")
                .frame(width: .none, height: .none, alignment: .leading)
            Spacer()
            
        }
        .font(InvestedCoinListConstants.bodyFont)
        .lineLimit(InvestedCoinListConstants.bodyLineLimit)
        .minimumScaleFactor(InvestedCoinListConstants.bodyMinimumScaleFactor)
        .padding([.top, .bottom], InvestedCoinListConstants.bodyVerticalPadding)
        .padding([.leading, .trailing], InvestedCoinListConstants.bodyHorizontalPadding)
        .frame(width: .none, height: InvestedCoinListConstants.bodyHeight, alignment: .leading)
    }
}
