//
//  CoinPricesInteractor.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CoinPricesInteractor {

  private let worker: CoinPricesWorker = CryptoCompareApi()
  private let presenter: CoinPricesPresentable
  
  init(presenter: CoinPricesPresentable) {
    self.presenter = presenter
  }
}


extension CoinPricesInteractor: CoinPricesBusinessLogic {
  
  func fetchCoins(with request: CoinPrices.FetchRequest) {
    worker.fetchCoins(with: request).then {
      print("PRESENTER: \($0.count)")
      self.presenter.presentFetchedCoins(for: CoinPrices.Response(coins: $0))
    }.catch {
      if let error = $0 as? AppModels.AppError {
        self.handle(error: error)
      }
    }
  }
  
  private func handle(error: AppModels.AppError) {
    print(error.description)
  }
}
