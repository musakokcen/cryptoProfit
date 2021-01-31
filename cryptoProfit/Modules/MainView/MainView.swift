//
//  MainView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import SwiftUI

struct MainView: View {
    @State private var coinList: [CoinInfo] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        Spacer()
                        Text("Select Coin")
                            //                            .font(.custom(Fonts.quicksandSemiBold, size: 18))
                            .padding([.top, .leading])
                        Spacer()
                    }
                    
                    ForEach(coinList, id: \.id) { coin in
                        if UIImage(named: "color/\(coin.symbol)") != nil {
                            NavigationLink(destination: CoinView(coin: coin)) {
                                CoinItem(coin: coin)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Crypto Profit")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            fetchCoinList()
        })
    }
    
    private func fetchPriceForCoin() {
        NetworkManager.shared.request(type: CoinPrice.self, endpoint: Endpoint.simplePrice(query: CoinPriceParams(id: "bitcoin", currency: "usd"))) { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func fetchCoinList() {
        DispatchQueue.main.async {
            NetworkManager.shared.request(type: [CoinInfo].self, endpoint: Endpoint.coinsList) { (result) in
                switch result {
                case .success(let data):
                    print(data)
                    coinList.append(contentsOf: data)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
