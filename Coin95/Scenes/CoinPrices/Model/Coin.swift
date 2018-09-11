//
//  CoinRealm.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/29/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoCompareAPI

class Coin: Object {
  @objc dynamic var name = ""
  @objc dynamic var symbol = ""
  @objc dynamic var imageUrlString: String?
  
  let tradingInfo = List<TradingInfo>()
  
  override static func primaryKey() -> String? {
    return "symbol"
  }
}


// MARK: - Computed propertires & helpers
extension Coin {
  var imageUrl: URL? {
    set {
      imageUrlString = newValue?.absoluteString
    }
    
    get {
      guard let imageUrlString = imageUrlString else {
        return nil
      }
      
      return URL(string: imageUrlString)
    }
  }
  
  func tradingInfo(for currency: String, exchange: Exchange) -> TradingInfo {
    return tradingInfo.first(where: {
      $0.currency == currency && $0.exchange == exchange
    })!
  }
}
