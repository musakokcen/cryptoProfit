//
//  CoinView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 19.01.2021.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct CoinView: View {
    let coin: CoinInfo
    
    @State var purchasedPrice: String = ""
    @State var purchasedAmount: String = ""
    @State private var purchasedDate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("color/\(coin.symbol)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
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
                    TextField("enter purchased price", text: $purchasedPrice, onCommit:  {
//                        hideKeyboard()
                    })
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .padding(.trailing)
                    // include currency selection
//                    Picker(<#T##titleKey: LocalizedStringKey##LocalizedStringKey#>, selection: <#T##Binding<_>#>, content: <#T##() -> _#>)
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
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .padding(.trailing)
                    .minimumScaleFactor(0.5)
                }
                
                HStack {
                    Spacer()
                    Button("Track") {

                    }
                    .font(Font.system(size: 22, weight: .heavy))
                    Spacer()
                }
            }
        }
//        .onTapGesture {
//            hideKeyboard()
//                }
    }
    
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(coin: CoinInfo(id: "bitcoin", symbol: "Btc", name: "Bitcoin"), purchasedPrice: "34,850.5", purchasedAmount: "0.04")
    }
}
