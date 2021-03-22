//
//  InvestedCoinList.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 2.03.2021.
//

import SwiftUI
import WidgetKit

struct InvestedCoinList: View {
    var coin: PurchasedCoin
    var profitValue: Double
    var profitPercentage: Double
    
    @State var coinIcon = Image(systemName: "creditcard.circle")
    
    
    init(coin: PurchasedCoin, profit: Double, profitPercentage: Double) {
        self.coin = coin
        self.profitValue = profit
        self.profitPercentage = profitPercentage
    }
    
    var body: some View {
        HStack {
            coinIcon
                .resizable()
                .frame(width: 30, height: 30, alignment: .leading)
            
            Text(coin.symbol)
                .font(Font.custom("Quantico-Bold", size: 12))
                .textCase(.uppercase)
                .frame(width: .none, height: .none, alignment: .leading)
            Text("\(coin.latestPrice)") // "\(profitValue, specifier: "%.2f")$")
                .frame(width: .none, height: .none, alignment: .leading)
            Image(systemName: profitValue > 0 ? "arrow.up.square.fill" : "arrow.down.square.fill")
                .foregroundColor(profitValue > 0 ?  .green : .red)
                .font(.system(size: 20, weight: .thin))
            
            Text("%\(profitPercentage, specifier: "%.2f"))")
                .frame(width: .none, height: .none, alignment: .leading)
            Text("\(profitValue)")
                .frame(width: .none, height: .none, alignment: .leading)
            
        }
        .font(Font.custom("Quantico-Regular", size: 12))
        .lineLimit(1)
        .minimumScaleFactor(0.4)
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 8)
        .frame(width: .none, height: 60, alignment: .leading)
    }
}
