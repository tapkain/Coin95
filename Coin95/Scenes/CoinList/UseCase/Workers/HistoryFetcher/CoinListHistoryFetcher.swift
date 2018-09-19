//
//  CoinListHistoryFetcher.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

protocol CoinListHistoryFetcher {
  func fetchHistory(for coin: Coin, _ request: CoinListRequest) -> Promise<Void>
}
