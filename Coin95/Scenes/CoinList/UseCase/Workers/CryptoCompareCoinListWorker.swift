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

struct CryptoCompareCoinListWorker: CoinListWorker {
  private let api: CryptoCompareAPI
  private let tradingInfoWorker: CryptoCompareTradingInfoWorker
  
  init() {
    api = CryptoCompareAPI()
    tradingInfoWorker = CryptoCompareTradingInfoWorker(api: api)
  }
  
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult> {
    return api.send(GetCoinListRequest()).then { coinList in
      self.tradingInfoWorker.fetchTradingInfo(for: coinList, with: request).then {
        self.save(coinList, tradingInfo: $0)
      }
    }
  }
  
  private func save(_ coinList: CoinListResponse, tradingInfo: GetSymbolsFullDataRequest.Response.CoinData) -> Promise<Coin.FetchResult> {
    return Promise { fulfill, _ in
      try Coin.write { transaction in
        coinList.forEach {
          transaction.create(coinListItem: $0.value, tradingInfo: tradingInfo[$0.key])
        }
      }
      
      DispatchQueue.main.async {
        fulfill(Coin.fetchAll())
      }
    }
  }
  
//  func fetchHistory(for coinList: CoinListResponse, with request: CoinPrices.FetchRequest) -> Promise<Void> {
//    return all(coinList.map {
//      self.fetchHistory(for: $0.key, with: request)
//    }).then {_ in return Promise(()) }
//  }
//
//  func fetchHistory(for symbol: String, with request: CoinPrices.FetchRequest) -> Promise<Void> {
//    let apiRequest = GetHistoricalDailyRequest(
//      fsym: symbol,
//      tsym: "USD",
//      e: request.exchange
//    )
//
//    return api.send(apiRequest).then { historicalData in
//      try Coin.write { transaction in
//        let coin: Coin = transaction.create(primaryKey: symbol)
//        coin.historicalInfo.removeAll()
//        coin.historicalInfo.append(objectsIn: historicalData.map {
//          transaction.create(historyEntry: $0, symbol: symbol)
//        })
//      }
//      }.recover { error -> Void in
//        guard let serverError = error as? CryptoCompareError else {
//          throw error
//        }
//
//        switch serverError {
//        case .server(_):
//          return
//        default:
//          throw error
//        }
//    }
//  }
}
