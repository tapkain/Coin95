//
//  CoinCapDataTransferObjects.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum CoinCap {
  struct History: Decodable {
    enum CodingKeys: String, CodingKey {
      case marketCap = "market_cap", price, volume
    }
    
    let marketCap: [[Double]]?
    let price: [[Double]]
    let volume: [[Double]]?
  }
}
