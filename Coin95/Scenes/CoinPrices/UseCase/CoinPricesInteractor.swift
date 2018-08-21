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
      case let .success(coins):
        self.presenter.presentFetchedCoins(for: CoinPrices.Response(coins: coins))
        
      case .failure(.noInternetConnection):
        print("No Internet")
        
      case .failure(.noData):
        print("No data")

      case .failure(.badData):
        print("Bad data")

      case .failure(.requestError):
        print("Request error")
      
      default:
        print("Default case")
      }
    }
  }
  
  func resolveWorker(from source: CoinPrices.FetchRequest.Source) -> CoinPricesWorker {
    switch source {
    case .coinMarketCap:
      return CoinMarketCap.Worker()
    }
  }
}
