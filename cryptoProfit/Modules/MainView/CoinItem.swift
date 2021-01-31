//
//  CoinItem.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 19.01.2021.
//

import SwiftUI

struct CoinItem: View {
    var coin: CoinInfo
    @State var coinIcon: UIImage?
    
    var body: some View {
        HStack {
            if let image = UIImage(named: "color/\(coin.symbol)") {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .leading)
            }
            Text(coin.symbol)
                .font(Font.headline.weight(.bold))
                .textCase(.uppercase)
                .frame(width: 100, height: 30, alignment: .leading)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(Font.headline.weight(.medium))
                .textCase(.none)
                .minimumScaleFactor(0.5)
            Spacer()
        }.padding(40)
        .frame(width: .none, height: 60, alignment: .leading)
        .onAppear(perform: {
            fetchIcon()
        })
    }
    
    private func fetchIcon() {

    }
}

struct CoinItem_Previews: PreviewProvider {
    static var previews: some View {
        let coin = CoinInfo(id: "bitcoin", symbol: "btc", name: "Bitcoin")
        CoinItem(coin: coin, coinIcon: nil)
            .previewLayout(.sizeThatFits)
    }
}
