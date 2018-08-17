//
//  CoinPricesInteractor.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CoinPricesInteractor {

  private let presenter: CoinPricesPresentable
  
  init(presenter: CoinPricesPresentable) {
    self.presenter = presenter
  }
}


extension CoinPricesInteractor: CoinPricesBusinessLogic {
  
  func fetchCoins(with request: CoinPrices.FetchRequest) {
    resolveWorker(from: request.source).fetchCoins(with: request) { result in
      switch result {
      case let .success(coin):
        print("Success!")
        
      case .error(.noInternetConnection):
        print("No Internet")
      }
    }
  }
  
  func resolveWorker(from source: CoinPrices.FetchRequest.Source) -> CoinPricesWorker {
    switch source {
    case .coinMarketCap:
      return CoinPricesCoinMarketCapWorker()
    }
  }
}
