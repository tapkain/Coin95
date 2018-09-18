//
//  ViewModel.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import Charts

struct CoinListViewModel {
  var coins: Results<Coin>!
  var setup: ((Coin) -> CoinViewModel)!
  
  var count: Int {
    guard let coins = coins else {
      return 0
    }
    return coins.count
  }
  
  init(coins: Results<Coin>! = nil, setup: ((Coin) -> CoinViewModel)! = nil) {
    self.coins = coins
    self.setup = setup
  }
}

struct CoinViewModel {
  let coinName: String
  let imageUrl: URL?
  let symbol: String
  let price: String
  let priceChange1h: PriceChange
  let priceChange24h: PriceChange
  let priceChange7d: PriceChange
  
  struct PriceChange {
    let delta: String
    let color: UIColor
  }
}
