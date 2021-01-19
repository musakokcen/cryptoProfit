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
            if let image = coinIcon {
                Image(uiImage: image)
            }
            Text(coin.symbol)
                .font(Font.headline.weight(.bold))
                .textCase(.uppercase)
                .frame(width: 100, height: 30, alignment: .leading)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(Font.headline.weight(.light))
                .textCase(.lowercase)
            Spacer()
        }.padding(40)
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
    }
}
