//
//  CryptoCompareCoinListWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CryptoCompareAPI
import Promises

struct CryptoCompareCoinListWorker {
  private let api: CryptoCompareAPI
  private let tradingInfoWorker: CryptoCompareTradingInfoWorker
  
  init() {
    api = CryptoCompareAPI()
    tradingInfoWorker = CryptoCompareTradingInfoWorker(api: api)
  }
  
  func fetchCoins(_ request: CoinListRequest) -> Promise<Void> {
    return api.send(GetCoinListRequest()).then { coinList in
      self.tradingInfoWorker.fetchTradingInfo(for: coinList, with: request).then {
        self.save(coinList, tradingInfo: $0, request)
      }
    }
  }
  
  private func save(
    _ coinList: CoinListResponse,
    tradingInfo: GetSymbolsFullDataRequest.Response.CoinData,
    _ request: CoinListRequest
    ) -> Promise<Void> {
    return Promise { fulfill, _ in
      try Coin.write { transaction in
        coinList.forEach {
          transaction.create(coinListItem: $0.value, tradingInfo: tradingInfo[$0.key])
        }
      }
      
      fulfill(())
    }
  }
}
