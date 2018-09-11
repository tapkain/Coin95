//
//  CoinPricesModels.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CryptoCompareAPI
import RealmSwift

enum CoinPrices {

  struct FetchRequest {
    
    let exchange: Exchange
    let symbol: String
    let toSymbol: String
    
    static let initial = FetchRequest(exchange: .defaultMarket, symbol: "", toSymbol: "USD,EUR")
  }
  
  struct Response {
    let coins: Results<Coin>
  }
  
  struct ViewModel {
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
    let priceChartData: Charts.ChartData
    let priceChange: PriceChange
    
    struct PriceChange {
      let delta: String
      let color: UIColor
    }
  }
}
