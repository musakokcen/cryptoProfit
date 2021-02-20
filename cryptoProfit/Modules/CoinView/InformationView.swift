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
                    .font(.system(size: 24.0, weight: .regular))
                    .fixedSize()

                Spacer()
                TextField(isMainInfo ? "Enter Price $" : "Enter Price $", text: isMainInfo ? $investmentDetails.purchasedPrice : $investmentDetails.updatedWithPrice)
                    .font(.system(size: 24.0, weight: .regular))
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
                    .font(.system(size: 24.0, weight: .regular))
                    .fixedSize()
                Spacer()
                
                TextField(isMainInfo ? "Enter Amount" : "Enter Amount", text: isMainInfo ? $investmentDetails.purchasedAmount : $investmentDetails.updatedWithAmount)
                    .font(.system(size: 24.0, weight: .regular))
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


/*
 struct CustomTextField: UIViewRepresentable {

     class Coordinator: NSObject, UITextFieldDelegate {

         @Binding var text: String
         var didBecomeFirstResponder = false

         init(text: Binding<String>) {
             _text = text
         }

         func textFieldDidChangeSelection(_ textField: UITextField) {
             text = textField.text ?? ""
         }

     }

     @Binding var text: String
     var isFirstResponder: Bool = false

     func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
         let textField = UITextField(frame: .zero)
         textField.delegate = context.coordinator
         textField.font = .systemFont(ofSize: 30, weight: .regular)
         textField.keyboardType = .decimalPad
         textField.textAlignment = .right
         textField.keyboardType = .decimalPad
         
         return textField
     }

     func makeCoordinator() -> CustomTextField.Coordinator {
         return Coordinator(text: $text)
     }

     func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
         uiView.text = text
         if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
             uiView.becomeFirstResponder()
             context.coordinator.didBecomeFirstResponder = true
         }
     }
 }
 */
