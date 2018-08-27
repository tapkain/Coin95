//
//  Formatter.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct Formatter {
  static var currency: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }
}


extension NumberFormatter {
  func string(from number: Double) -> String? {
    return string(from: NSNumber(value: number))
  }
}
