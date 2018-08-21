//
//  CoinPricesUseCases.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Result

protocol CoinPricesView: class {
  func displayFetchedCoins(with viewModel: CoinPrices.ViewModel)
  func display(error: AppModels.AppError)
}

protocol CoinPricesBusinessLogic {
  func fetchCoins(with request: CoinPrices.FetchRequest)
}

protocol CoinPricesPresentable {
  func presentFetchedCoins(for response: CoinPrices.Response)
  func presentFetchedCoins(error: AppModels.AppError)
}

protocol CoinPricesWorker {
  func fetchCoins(with request: CoinPrices.FetchRequest, _ completion: @escaping (Result<[CoinPrice], AppModels.AppError>) -> Void)
}
