//
//  HomeView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI

struct HomeViewConstants {
    static let navigationBarFont: UIFont? = UIFont(name: "Quantico-Regular", size: 36)
    static let pickerTitle: Text = Text(Localizable.viewSelection)
    static let popularCoins: Text = Text(Localizable.popularCoins)
    static let investedCoins: Text = Text(Localizable.investedCoins)
    static let loadMore: String = Localizable.loadMore
    static let loadMoreColor: UIColor = UIColor(named: "whiteColor")!
    static let loadMoreFont: Font = Font.custom("Quantico-Regular", size: 20)
    static let scrollBarFont: Font = Font.custom("Quantico-Regular", size: 16)
    static let coinsPerPage: Int = 50
    
    struct SearchBar {
        static let icon: String = "magnifyingglass"
        static let search: String = "Search"
        static let cancel: String = "xmark.circle.fill"
        static let padding: EdgeInsets = EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6)
        static let cornerRadius: CGFloat = 10
        static let cancelText: String = "Cancel"
    }

}

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
        if let font = HomeViewConstants.navigationBarFont {
            UINavigationBar.appearance().titleTextAttributes = [.font : font]
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        Spacer()
                        Picker(selection: $selectedView, label: HomeViewConstants.pickerTitle) {
                            HomeViewConstants.popularCoins.tag(0)
                            HomeViewConstants.investedCoins.tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        Spacer()
                    }
                    if selectedView == 0 {
                        HStack {
                            HStack {
                                Image(systemName: HomeViewConstants.SearchBar.icon)

                                TextField(HomeViewConstants.SearchBar.search, text: $searchText, onEditingChanged: { isEditing in
                                    self.showCancelButton = true
                                }, onCommit: {
                                    print("onCommit")
                                }).foregroundColor(.primary)

                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: HomeViewConstants.SearchBar.cancel).opacity(searchText == "" ? 0 : 1)
                                }
                            }
                            .padding(HomeViewConstants.SearchBar.padding)
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(HomeViewConstants.SearchBar.cornerRadius)

                            if showCancelButton  {
                                Button(HomeViewConstants.SearchBar.cancelText) {
                                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                        self.searchText = ""
                                        self.showCancelButton = false
                                }
                                .foregroundColor(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarHidden(showCancelButton)
                        ForEach(coinList.filter{$0.name.contains(searchText) || searchText == ""}, id: \.id) { coin in
                            CoinListItem(coin: coin)
                        }
                        Spacer()
                        Button(HomeViewConstants.loadMore) {
                            fetchCoinList()
                        }
                        .foregroundColor(Color(HomeViewConstants.loadMoreColor))
                        .font(HomeViewConstants.loadMoreFont)
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
            .font(HomeViewConstants.scrollBarFont)
            .onAppear(perform: {
                if investmentList != UserDefaultsConfig.purchasedCryptoCoins {
                    investmentList = UserDefaultsConfig.purchasedCryptoCoins
                }
            })
            .navigationBarTitle(Localizable.cryptoProfit, displayMode: .inline)
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
            NetworkManager.shared.request(type: [CoinMarketData].self, endpoint: Endpoint.coinMarketData(query: coinMarketDataParams(currency: Currency.USD.name.lowercased().replacingOccurrences(of: " ", with: ""), ids: nil, coinsPerPage: HomeViewConstants.coinsPerPage, page: fetchedCoinListPage, priceChangeRange: nil))) { (result) in
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
