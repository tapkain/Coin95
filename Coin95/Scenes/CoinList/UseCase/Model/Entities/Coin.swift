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

final class Coin: Object {
  @objc dynamic var name = ""
  @objc dynamic var symbol = ""
  @objc dynamic var imageUrlString: String?
  
  let tradingInfo = LinkingObjects(fromType: TradingInfo.self, property: "coin")
  let historicalInfo = List<CoinHistoryEntry>()
  
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
}
