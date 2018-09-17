//
//  CoinListPresentable.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

protocol CoinListPresentable {
  func present(coins: Coin.FetchResult, _ request: CoinListRequest)
  func present(error: AppModels.AppError)
}
