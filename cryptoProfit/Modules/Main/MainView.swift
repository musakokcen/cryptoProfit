//
//  MainView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(perform: {
                NetworkManager.shared.request(type: CoinPrice.self, endpoint: Endpoint.coinPrice(info: CoinPriceParams(id: "bitcoin", currency: "usd"))) { (result) in
                    switch result {
                    case .success(let data):
                        print(data)
                    case .failure(let err):
                        print(err)
                    }
                }
            })
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
