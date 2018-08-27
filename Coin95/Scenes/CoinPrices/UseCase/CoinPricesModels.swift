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

enum CoinPrices {

  struct FetchRequest {
    enum Source {
      case coinMarketCap
    }
    
    init(source: Source, start: Int = 0, limit: Int = 100) {
      self.source = source
      self.start = start
      self.limit = limit
      self.symbol = ""
      self.historyPeriod = 0
    }
    
    init(symbol: String, historyPeriod: Int = 7) {
      self.symbol = symbol
      self.historyPeriod = historyPeriod
      self.source = .coinMarketCap
      self.start = 0
      self.limit = 0
    }
    
    let source: Source
    let start: Int
    let limit: Int
    let symbol: String
    let historyPeriod: Int
  }
  
  struct Response {
    let coins: [CoinPrice]
  }
  
  struct ViewModel {
    let coins: [CoinViewModel]
  }
  
  struct CoinViewModel {
    let coinImage: UIImage?
    let coinName: String
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
