//
//  CoinView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 19.01.2021.
//

import SwiftUI
import Introspect

struct CoinView: View {
    let coin: CoinMarketData
    
    @State var purchasedPrice: String = ""
    @State var purchasedAmount: String = ""
    @State private var purchasedDate = Date()
    @State var currency: Currency = Currency.USD
    @State var showCurrencySelector: Bool = false
   
    var coinIcon: Image
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    coinIcon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: .center)
                        
                        HStack {
                            Text(coin.symbol)
                                .font(Font.headline.weight(.bold))
                                .textCase(.uppercase)
                                .minimumScaleFactor(0.5)
                                .frame(width: .none, height: .none, alignment: .leading)
                                .padding(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("(" + coin.name + ")")
                                .font(Font.headline.weight(.medium))
                                .textCase(.none)
                                .minimumScaleFactor(0.5)
                                .padding(.leading)
                            Spacer()
                        }
                        Spacer().frame(width: .none, height: 30, alignment: .center)
                        HStack {
                            Text("Purchased at: ")
                                .padding(.leading)
                            Spacer()
                            TextField("enter purchased price", text: $purchasedPrice)
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
                            Picker(currency.name, selection: $currency) {
                                ForEach(Currency.allCases) { v in
                                    Text(v.name).tag(v)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.trailing)
                            .foregroundColor(.black)
                        }
                        HStack {
                            Text("*If you enter the purchase price, you can track the actual profit.")
                                .font(Font.system(size: 12, weight: .light, design: .serif))                        .minimumScaleFactor(0.4)
                                .padding(EdgeInsets(.init(top: 0, leading: 30, bottom: 0, trailing: 4)))
                                .lineLimit(1)
                        }
                        HStack {
                            DatePicker(selection: $purchasedDate, in: ...Date(), displayedComponents: .date) {
                                Text("Purchased Date: ")
                                    .padding(.leading)
                            }
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                            //                    Spacer()
                        }
                        HStack {
                            Text("*retrives the average price of the date.")
                                //                        .font(Font.headline.weight(.light))
                                .font(Font.system(size: 12, weight: .light, design: .serif))
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.4)
                                .padding(EdgeInsets(.init(top: 0, leading: 30, bottom: 0, trailing: 4)))
                                .lineLimit(1)
                            Spacer()
                        }
                        HStack {
                            Text("Purchased amount: ")
                                .padding(.leading)
                            Spacer()
                            TextField("enter purchased amount", text: $purchasedAmount, onCommit:  {
                                //                        hideKeyboard()
                            })
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
                    
                        HStack {
                            Spacer()
                            Button("Start Tracking") {
                                
                            }
                            .font(Font.system(size: 22, weight: .heavy))
                            .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(EdgeInsets(.init(top: 50, leading: 0, bottom: 0, trailing: 0)))
                }
                if showCurrencySelector {
                    Picker("Currency", selection: $currency) {
                        ForEach(Currency.allCases) { v in
                            Text(v.name).tag(v)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
                Spacer()
        }
        //        .onTapGesture {
        //            hideKeyboard()
        //                }
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
        CoinView(coin: data, purchasedPrice: "34,850.5", purchasedAmount: "0.04", coinIcon: Image(systemName: "creditcard.circle"))
    }
}
