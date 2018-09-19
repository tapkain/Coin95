//
//  CoinListCoinFetcher.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

protocol CoinListCoinFetcher {
  func fetchCoins(_ request: CoinListRequest) -> Promise<Coin.FetchResult>
}
