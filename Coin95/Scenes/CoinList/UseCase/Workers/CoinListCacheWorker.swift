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

struct CoinListCacheWorker: CoinListHistoryFetcher, CoinListCoinFetcher {
  private let api: CryptoCompareAPI
  private let coinFetcher: CoinListCoinFetcher
  private let historyFetcher: CoinListHistoryFetcher
  
  init() {
    api = CryptoCompareAPI(applicationName: nil, logRequests: false)
    coinFetcher = CryptoCompareCoinListWorker(api: api)
    historyFetcher = CoinListHistoryWorker(api: api)
  }
  
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    if shouldFetchFromAPI() {
      return coinFetcher.fetchCoins(request)
    }
    
    return fetchCoinsLocal(request)
  }
  
  func fetchHistory(for coin: Coin, _ request: CoinListRequest) -> Promise<Void> {
    if shouldFetchFromAPI() {
      return historyFetcher.fetchHistory(for: coin, request)
    }
    return Promise(())
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
    return false
  }
  
  // TODO: Duplicate with worker
  private func fetchCoinsLocal(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    return Promise { fulfill, _ in
      DispatchQueue.main.async {
        fulfill(Coin.fetchAll(for: request))
      }
    }
  }
}
