//
//  CoinListHistoryWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CryptoCompareAPI
import Promises

struct CoinListHistoryWorker {
  enum HistoryPeriod {
    case for24h
    case for7d
  }
  
  let api: CryptoCompareAPI
  
  func fetchHistory(_ coin: Coin, _ request: CoinListRequest, for period: HistoryPeriod = .for24h) -> Promise<Void> {
    let apiRequest = GetHistoricalHourlyRequest(fsym: coin.symbol, tsym: request.currency, e: Exchange(rawValue: request.exchange)!)
    
    return api.send(apiRequest).then { history in
      return Promise { fulfill, _ in
        try CoinHistoryEntry.write { transaction in
          history.forEach {
            transaction.create(historyEntry: $0, symbol: coin.symbol)
          }
        }
        
        fulfill(())
      }
    }
  }
}
