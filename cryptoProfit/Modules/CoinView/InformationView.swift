//
//  InformationView.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 20.02.2021.
//

import SwiftUI

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
                    .fixedSize()

                Spacer()
                TextField(isMainInfo ? "Enter Price $" : "Enter Price $", text: isMainInfo ? $investmentDetails.purchasedPrice : $investmentDetails.updatedWithPrice)
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
                    .fixedSize()
                Spacer()
                
                TextField(isMainInfo ? "Enter Amount" : "Enter Amount", text: isMainInfo ? $investmentDetails.purchasedAmount : $investmentDetails.updatedWithAmount)
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
        .font(Font.custom("Quantico-Regular", size: 24))
    }
}
