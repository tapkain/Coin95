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
  private let coinListCache: CoinListHistoryFetcher & CoinListCoinFetcher = CoinListCacheWorker()
  private let presenter: CoinListPresentable
  
  init(presenter: CoinListPresentable) {
    self.presenter = presenter
  }
}


extension CoinListInteractor: CoinListUseCase {
  func fetchCoins(_ request: CoinListRequest) -> Promise<CoinListViewModel> {
    print("\nFetch coins:\n \(request.description)\n")
    
    return coinListCache.fetchCoins(request).then { coins in
      return Promise { fulfill, _ in
        DispatchQueue.main.async {
          let viewModel = self.presenter.present(coins: coins, request)
          return fulfill(viewModel)
        }
      }
    }.catch {
      self.handle(error: $0)
    }
  }
  
  func fetchHistory(for coin: Coin, _ request: CoinListRequest) {
    print("Fetch history for \(coin.symbol)")
    _ = coinListCache.fetchHistory(for: coin, request)
  }
  
  private func handle(error: Error) {
    print(error.localizedDescription)
  }
}
