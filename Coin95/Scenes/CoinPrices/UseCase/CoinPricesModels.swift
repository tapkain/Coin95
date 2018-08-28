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
    enum Exchanges: String {
      case coinbase
      case kraken
      case binance
      case general = "CCCAGG"
    }
    
    let exchange: Exchanges
    let symbol: String
    let toSymbol: String
    
    static let initial = FetchRequest(exchange: .general, symbol: "", toSymbol: "USD,EUR")
  }
  
  struct Response {
    let coins: [Coin]
  }
  
  struct ViewModel {
    let coins: [CoinViewModel]
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
