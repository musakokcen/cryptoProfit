//
//  HomeView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var coinList: [CoinMarketData] = []
    @State private var investmentList: [PurchasedCoin]? = UserDefaultsConfig.purchasedCryptoCoins {
        didSet {
            selectedView = (investmentList?.count ?? 0) > 0 ? 1 : 0
        }
    }
    
    @State private var selectedView = (UserDefaultsConfig.purchasedCryptoCoins?.count ?? 0) > 0 ? 1 : 0
    
    @State private var fetchedCoinListPage = 1
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
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
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")

                                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                                    self.showCancelButton = true
                                }, onCommit: {
                                    print("onCommit")
                                }).foregroundColor(.primary)

                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)

                            if showCancelButton  {
                                Button("Cancel") {
                                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                        self.searchText = ""
                                        self.showCancelButton = false
                                }
                                .foregroundColor(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
                        ForEach(coinList.filter{$0.name.contains(searchText) || searchText == ""}, id: \.id) { coin in
                            CoinListItem(coin: coin)
                        }
                        Spacer()
                        Button("Load More") {
                            fetchCoinList()
                        }
                        .font(Font.system(size: 22, weight: .heavy))
                        .foregroundColor(Color(UIColor(named: "whiteColor")!))
                    } else {
                        if let investmentList = investmentList {
                            ForEach(investmentList, id: \.id) { coin in
                                if let coin = coinList.first(where: {$0.id == coin.id}) {
                                    InvestmentListItem(coin: coin)
                                }
                            }
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
            }
            .onAppear(perform: {
                if investmentList != UserDefaultsConfig.purchasedCryptoCoins {
                    investmentList = UserDefaultsConfig.purchasedCryptoCoins
                }
            })
            .navigationBarTitle("Crypto Profit", displayMode: .inline)
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
            
            self.fetchedCoinListPage += 1
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


// search bar extensions
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
