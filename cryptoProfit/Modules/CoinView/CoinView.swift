//
//  CoinView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 19.01.2021.
//

import SwiftUI
import Introspect

class InvestmentDetails: ObservableObject {
    @Published var purchasedPrice: String = ""
    @Published var purchasedAmount: String = ""
    @Published var updatedWithPrice: String = ""
    @Published var updatetWithAmount: String = ""
}

struct CoinView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let coin: CoinMarketData
    
    @ObservedObject var investmentDetails = InvestmentDetails()
    
    @State private var purchasedDate = Date()
    @State var currency: Currency = Currency.USD
    @State var showCurrencySelector: Bool = false
    @State var showInsertDeleteButtons: Bool = false
    @State var isAdditionalInfoViewHidden: Bool = true
    @State var buttonTitle: String = "Add Investment"
    @State var isPlusTapped: Bool = false
    
    var coinIcon: Image
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content:  {
                ZStack {
                    VStack(spacing: 24) {
                        
                        Spacer().frame(width: .none, height: 0, alignment: .center)
                        
                        coinIcon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width / 3, height: geometry.size.width / 3, alignment: .center)
                        
                        VStack(spacing: 8) {
                            Text("\(coin.currentPrice, specifier: "%.2f")$")
                                .font(Font.headline.weight(.bold))
                                .textCase(.uppercase)
                                .minimumScaleFactor(0.5)
                                .frame(width: .none, height: .none, alignment: .leading)
                            
                            HStack {
                                Image(systemName: coin.priceChangePercentage24H > 0 ? "arrow.up.square.fill" : "arrow.down.square.fill")
                                    .foregroundColor(coin.priceChangePercentage24H > 0 ?  .green : .red)
                                    .font(.system(size: 30.0, weight: .thin))
                                Text("%\(coin.priceChangePercentage24H, specifier: "%.2f")")
                            }
                        }
                        
                        Spacer().frame(width: .none, height: 24, alignment: .center)
                        
                        InformationView(isMain: true, details: investmentDetails).environmentObject(investmentDetails)
                        
                        if !isAdditionalInfoViewHidden {
                            InformationView(isMain: false, details: investmentDetails)
                        }
                        
                        if showInsertDeleteButtons {
                            HStack {
                                Button(action: {
                                    isAdditionalInfoViewHidden = false
                                    isPlusTapped = true
                                    showInsertDeleteButtons = false
                                }) {
                                    Image(uiImage: UIImage(named: "insert")!)
                                }
                                
                                Spacer()
                                    .frame(width: 54, height: .none, alignment: .center)
                                
                                Button(action: {
                                    isAdditionalInfoViewHidden = false
                                    isPlusTapped = false
                                    showInsertDeleteButtons = false
                                }) {
                                    Image(uiImage: UIImage(named: "remove")!)
                                }
                            }
                        }
                        
                        if !showInsertDeleteButtons {
                            HStack {
                                Spacer()
                                Button(buttonTitle) {
                                    updateInvestments()
                                }
                                .font(Font.system(size: 22, weight: .heavy))
                                .foregroundColor(Color(UIColor(red: 0.36, green: 0.725, blue: 0.072, alpha: 1)))
                                Spacer()
                            }
                            .padding(EdgeInsets(.init(top: 50, leading: 0, bottom: 0, trailing: 0)))
                            
                        }
                        
                        if showInsertDeleteButtons {
                            HStack {
                                Spacer()
                                Button("Remove Investment") {
                                    
                                    if var savedItems = UserDefaultsConfig.purchasedCryptoCoins {
                                        for index in 0..<savedItems.count {
                                            if savedItems[index].id == coin.id {
                                                savedItems.remove(at: index)
                                                break
                                            }
                                        }
                                        UserDefaultsConfig.purchasedCryptoCoins = savedItems
                                    }
                                    
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .font(Font.system(size: 22, weight: .heavy))
                                .foregroundColor(Color(UIColor(red: 0.742, green: 0.04, blue: 0.04, alpha: 1)))
                                Spacer()
                            }
                            .padding(EdgeInsets(.init(top: 50, leading: 0, bottom: 0, trailing: 0)))
                            
                        }
                        
                        
                        Spacer()
                            .frame(width: .none, height: geometry.size.height / 3, alignment: .center)
                        
                    }
                    //                    if showCurrencySelector {
                    //                        Picker("Currency", selection: $currency) {
                    //                            ForEach(Currency.allCases) { v in
                    //                                Text(v.name).tag(v)
                    //                            }
                    //                        }
                    //                        .pickerStyle(MenuPickerStyle())
                    //                    }
                }
            }
            )
        }
        .navigationBarTitle(Text(coin.name), displayMode: .inline)
        .font(.subheadline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Image("back")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
        )
        .onAppear(perform: {
            prepareView()
        })
    }
    
    private func prepareView() {
        if let savedItems = UserDefaultsConfig.purchasedCryptoCoins,
           let savedCoin = savedItems.first(where: {$0.id == coin.id}){
            investmentDetails.purchasedPrice = savedCoin.purchasedPrice
            investmentDetails.purchasedAmount = savedCoin.purchasedAmount
            showInsertDeleteButtons = true
            buttonTitle = "Update Investment"
        } else {
            showInsertDeleteButtons = false
            buttonTitle = "Add Investment"
        }
    }
    
    private func updateInvestments() {
        if investmentDetails.updatetWithAmount == "" {
            let purchasedItem = PurchasedCoin(purchasedPrice: investmentDetails.purchasedPrice,
                                              purchasedAmount: investmentDetails.purchasedAmount,
                                              id: coin.id,
                                              symbol: coin.symbol,
                                              name: coin.name,
                                              image: coin.image,
                                              latestPrice: coin.currentPrice,
                                              lastUpdated: coin.lastUpdated)
            if var savedItems = UserDefaultsConfig.purchasedCryptoCoins {
                if !savedItems.contains(where: {$0.id == purchasedItem.id}) {
                    savedItems.append(purchasedItem)
                    UserDefaultsConfig.purchasedCryptoCoins = savedItems
                }
            } else {
                UserDefaultsConfig.purchasedCryptoCoins = [purchasedItem]
            }
        } else {
            if var coins = UserDefaultsConfig.purchasedCryptoCoins,
               var item = coins.first(where: {$0.id == coin.id}) {
                guard let pAmount = Double(item.purchasedAmount),
                      let uAmount = Double(investmentDetails.updatetWithAmount.replacingOccurrences(of: ",", with: ".")),
                      let pPrice = Double(item.purchasedPrice)
                      
                else {return}
                
                if !isPlusTapped {
                    item.purchasedAmount = "\(pAmount - uAmount)"
                } else {
                    guard let uPrice = Double(investmentDetails.updatedWithPrice.replacingOccurrences(of: ",", with: ".")) else {return}
                    item.purchasedAmount = "\(pAmount + uAmount)"
                    let total = (pAmount * pPrice) + (uAmount * uPrice)
                    let average = total / (pAmount + uAmount)
                    item.purchasedPrice = "\(average)"
                }
                
                for index in 0..<coins.count {
                    if coins[index].id == coin.id {
                        coins[index] = item
                        break
                    }
                }
                
                UserDefaultsConfig.purchasedCryptoCoins = coins
                
            }
        }
        
        
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        let data = CoinMarketData(
            id: "bitcoin",
            symbol : "btc",
            name : "Bitcoin",
            image : "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            currentPrice : 33904.0456,
            marketCap : 630362181507,
            marketCapRank : 1,
            fullyDilutedValuation: 0,
            totalVolume: 0,
            high24H: 0,
            low24H: 0,
            priceChange24H: 0,
            priceChangePercentage24H: 3.0555,
            marketCapChange24H: 0,
            marketCapChangePercentage24H: 0,
            circulatingSupply: 0,
            totalSupply: 0,
            maxSupply: 0,
            ath: 0,
            athChangePercentage: 0,
            athDate: "string",
            atl: 0,
            atlChangePercentage: 0,
            atlDate: "String",
            roi: nil,
            lastUpdated: "String")
        
        CoinView(coin: data, coinIcon: Image(systemName: "creditcard.circle"))
    }
}

struct InformationView: View {
    
    @ObservedObject var investmentDetails: InvestmentDetails
    
    let isMainInfo: Bool
    init(isMain: Bool, details: InvestmentDetails) {
        self.isMainInfo = isMain
        self.investmentDetails = details
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(isMainInfo ? "Purchased at: " : "Price")
                    .padding(.leading)
                Spacer()
                TextField(isMainInfo ? "Enter Purchased Price $" : "Enter Price", text: isMainInfo ? $investmentDetails.purchasedPrice : $investmentDetails.updatedWithPrice)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .minimumScaleFactor(0.5)
                    .padding(.trailing)
                    .introspectTextField { (textField) in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                        doneButton.tintColor = .systemPink
                        toolBar.items = [flexButton, doneButton]
                        toolBar.setItems([flexButton, doneButton], animated: true)
                        textField.inputAccessoryView = toolBar
                    }
            }
            
            HStack {
                Text(isMainInfo ? "Purchased Amount: " : "Amount")
                    .padding(.leading)
                Spacer()
                
                TextField(isMainInfo ? "Enter Purchased Amount" : "Enter Amount", text: isMainInfo ? $investmentDetails.purchasedAmount : $investmentDetails.updatetWithAmount)
                    .minimumScaleFactor(0.5)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .padding(.trailing)
                    .introspectTextField { (textField) in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                        doneButton.tintColor = .systemPink
                        toolBar.items = [flexButton, doneButton]
                        toolBar.setItems([flexButton, doneButton], animated: true)
                        textField.inputAccessoryView = toolBar
                    }
                
            }
        }
    }
}
