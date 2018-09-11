//
//  CoinListInteractor.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

struct CoinListInteractor {
  private let coinListWorker: CoinListWorker = CoinListCacheWorker()
  private let presenter: CoinListPresentable
  
  init(presenter: CoinListPresentable) {
    self.presenter = presenter
  }
}


extension CoinListInteractor: CoinListUseCase {
  func fetchCoins(_ request: CoinListRequest) -> Promise<Void> {
    return coinListWorker.fetchCoins(request).then { coins in
      DispatchQueue.main.async {
        self.presenter.present(coins: coins)
      }
      return Promise(())
    }.catch {
      self.handle(error: $0)
    }
  }
  
  private func handle(error: Error) {
    print(error.localizedDescription)
  }
}
