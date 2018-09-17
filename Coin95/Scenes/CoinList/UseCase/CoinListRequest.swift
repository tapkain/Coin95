//
//  CoinListRequest.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CoinListRequest {
  enum SearchBy {
    case name(String)
    case none
  }
  
  enum SortBy: String {
    case marketCap
    case name
    case price
    case topGains
    case topLoss
  }
  
  enum FilterBy {
    case ico
    
  }
  
  static let initial = CoinListRequest(
    searchBy: .none,
    sortBy: .marketCap,
    currency: "USD",
    exchange: "CCCAGG"
  )
  
  var searchBy: SearchBy
  var sortBy: SortBy
  
  var currency: String
  var exchange: String
  
  init(searchBy: SearchBy, sortBy: SortBy, currency: String, exchange: String) {
    self.searchBy = searchBy
    self.sortBy = sortBy
    self.currency = currency
    self.exchange = exchange
  }
}
