//
//  CoinListWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

protocol CoinListWorker {
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult>
}
