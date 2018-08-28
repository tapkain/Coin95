//
//  Coin.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

class Coin: Object {
  @objc dynamic var name = ""
  @objc dynamic var symbol = ""
  @objc dynamic var priceChange = 0.0
  @objc dynamic var imageUrl: String?
  
  let prices = List<Price>()
  let pricePoints = List<Point>()
  
  func price(for currency: String) -> Double? {
    return prices.first(where: { $0.currency == currency })?.value
  }
}
