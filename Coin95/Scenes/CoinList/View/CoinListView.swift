//
//  CoinListView.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

protocol CoinListView: class {
  func displayFetchedCoins(with viewModel: CoinListViewModel)
  func display(error: AppModels.AppError)
  func refreshView()
}
