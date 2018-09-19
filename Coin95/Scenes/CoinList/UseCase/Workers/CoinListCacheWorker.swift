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
import CryptoCompareAPI

struct CoinListCacheWorker: CoinListWorker {
  private let apiWorker = CryptoCompareCoinListWorker()
  
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    if shouldFetchFromAPI() {
      print("CoinListCacheWorker - Fetching from API")
      return apiWorker.fetchCoins(request).then {
        self.fetchLocal(request)
      }
    }
    
    print("CoinListCacheWorker - Fething from local DB")
    return fetchLocal(request)
  }
  
  func shouldFetchFromAPI() -> Bool {
    // if is internet available
    // if should refresh cache {
    //    if cache refresh timeout is exceeded
    //    if there is no data in cache
    //    return true
    //} else return false
    //add error handling
    //return Reachability.forInternetConnection().isReachable()
    return true
  }
  
  private func fetchLocal(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    return Promise { fulfill, _ in
      DispatchQueue.main.async {
        fulfill(Coin.fetchAll(for: request))
      }
    }
  }
}
