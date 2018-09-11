//
//  CoinListCacheWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Reachability
import Promises

struct CoinListCacheWorker: CoinListWorker {
  private let apiWorker: CoinListWorker = CryptoCompareCoinListWorker()
  
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    if shouldFetchFromAPI() {
      return apiWorker.fetchCoins(request)
    }
    
    return fetchLocal()
  }
  
  private func shouldFetchFromAPI() -> Bool {
    return Reachability.forInternetConnection().isReachable()
  }
  
  private func fetchLocal() -> Promise<Coin.FetchResult> {
    return Promise { fulfill, _ in
      DispatchQueue.main.async {
        fulfill(Coin.fetchAll())
      }
    }
  }
}
