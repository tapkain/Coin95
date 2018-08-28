//
//  CoinPricesWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/28/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension CryptoCompareApi: CoinPricesWorker {
  
  func fetchCoins(with request: CoinPrices.FetchRequest) -> Promise<[Coin]> {
    return fetchAllCoins().then {
      return self.fetchCoinPrices(for: $0, with: request)
    }
  }
}
