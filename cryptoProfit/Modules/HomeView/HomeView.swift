//
//  HomeView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var coinList: [CoinMarketData] = []
    @State private var investmentList: [PurchasedCoin] = []
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
                    if selectedView == 0 {
                        ForEach(coinList, id: \.id) { coin in
                            CoinListItem(coin: coin)
                        }
                    } else {
                        ForEach(investmentList, id: \.id) { coin in
                            if let coin = coinList.first(where: {$0.id == coin.id}) {
                                InvestmentListItem(coin: coin)
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
            if let list = UserDefaultsConfig.purchasedCryptoCoins {
                investmentList = list
            }
        })
        .onChange(of: UserDefaultsConfig.purchasedCryptoCoins, perform: { value in
            if let list = UserDefaultsConfig.purchasedCryptoCoins {
                investmentList = list
            }
        })
    }
    
    private func fetchCoinList() {
        DispatchQueue.main.async {
            NetworkManager.shared.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: "usd", ids: nil, coinsPerPage: 50, page: fetchedCoinListPage, priceChangeRange: nil))) { (result) in
                switch result {
                case .success(let data):
                    let sortedData = data.sorted{$0.marketCap > $1.marketCap }
                    coinList.append(contentsOf: sortedData)
                    selectedView = UserDefaultsConfig.purchasedCryptoCoins == nil ? 0 : 1
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
