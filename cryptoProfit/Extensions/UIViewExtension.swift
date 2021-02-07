//
//  UIViewExtension.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
