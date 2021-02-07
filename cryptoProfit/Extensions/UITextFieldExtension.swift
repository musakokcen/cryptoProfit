//
//  UITextFieldExtension.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 31.01.2021.
//

import UIKit

extension  UITextField {
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
}
