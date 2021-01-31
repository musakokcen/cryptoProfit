//
//  HomeView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var coinList: [CoinMarketData] = []
    @State private var selectedView = 0
    private var fetchedCoinListPage = 1
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        Spacer()
                        Picker(selection: $selectedView, label: Text("View Selection")) {
                            Text("Popular Coins").tag(0)
                            Text("Invested Coins").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        Spacer()
                    }
                    
                    ForEach(coinList, id: \.id) { coin in
                        CoinListItem(coin: coin)
//                                NavigationLink(destination: CoinView(coin: coin)) {
//                                CoinItem(coin: coin)
//                            }
                        
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
    
    private func fetchCoinList() {
        DispatchQueue.main.async {
            NetworkManager.shared.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: "usd", ids: nil, coinsPerPage: 50, page: fetchedCoinListPage, priceChangeRange: nil))) { (result) in
                switch result {
                case .success(let data):
                    let sortedData = data.sorted{$0.marketCap > $1.marketCap }
                    coinList.append(contentsOf: sortedData)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
