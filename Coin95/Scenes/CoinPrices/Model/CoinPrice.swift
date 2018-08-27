//
//  CoinPriceRealm.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

class CoinPrice: Object {
  @objc dynamic var name = ""
  @objc dynamic var symbol = ""
  @objc dynamic var price = 0.0
  @objc dynamic var priceChange = 0.0
  let pricePoints = List<Point>()
}
