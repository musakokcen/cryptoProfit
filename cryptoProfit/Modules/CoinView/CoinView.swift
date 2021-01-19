//
//  CoinView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 19.01.2021.
//

import SwiftUI

struct CoinView: View {
    let coin: CoinInfo
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(/*@START_MENU_TOKEN@*/"Image Name"/*@END_MENU_TOKEN@*/)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
        }
    }
    
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(coin: CoinInfo(id: "bitcoin", symbol: "btc", name: "Bitcoin"))
        
    }
}
