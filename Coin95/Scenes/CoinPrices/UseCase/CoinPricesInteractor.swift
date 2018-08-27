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
    resolveWorker(from: request.source).fetchCoins(with: request).then {
      self.presenter.presentFetchedCoins(for: CoinPrices.Response(coins: $0))
    }.catch {
      if let error = $0 as? AppModels.AppError {
        switch error {
        case .noInternetConnection:
          print("No Internet connection")
          
        case .badData:
          print("bad data")
          
        case .noData:
          print("no data")
          
        case .requestError:
          print("bad request")
          
        default:
          print("lol")
        }
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
