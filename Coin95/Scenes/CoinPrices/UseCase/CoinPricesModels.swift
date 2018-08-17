//
//  CoinPricesModels.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum CoinPrices {

  struct FetchRequest {
    enum Source {
      case coinMarketCap
    }
    
    let source: Source
    let start = 0
    let limit = 100
  }
  
  struct Response {
    let coins: [Coin]
  }
  
  struct ViewModel {
    
  }
  
  
}
