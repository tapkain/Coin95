//
//  TradingInfo.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/28/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoCompareAPI

final class TradingInfo: Object {
  @objc dynamic var currency = ""
  @objc dynamic var volume = 0.0
  @objc dynamic var totalVolume = 0.0
  @objc dynamic var priceChange1h = 0.0
  @objc dynamic var priceChange24h = 0.0
  @objc dynamic var priceChange7d = 0.0
  @objc dynamic var marketCap = 0.0
  @objc dynamic var price = 0.0
  @objc dynamic var exchangeString = ""
  @objc dynamic var id = ""
  @objc dynamic var coin: Coin?
  
  override static func primaryKey() -> String? {
    return "id"
  }
}


// MARK: - Computed properties
extension TradingInfo {
  var exchange: Exchange {
    get {
      return Exchange(rawValue: exchangeString) ?? .defaultMarket
    }
    
    set {
      exchangeString = newValue.rawValue
    }
  }
  
  static func getId(currency: String, exchange: String, symbol: String) -> String {
    return "\(currency) \(exchange) \(symbol)"
  }
}
