//
//  CoinPricesPresenter.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CoinPricesPresenter {

  private let view: CoinPricesView
  
  init(view: CoinPricesView) {
    self.view = view
  }
}


extension CoinPricesPresenter: CoinPricesPresentable {
  
  func presentFetchedCoins(for response: CoinPrices.Response) {
    
  }
  
  func presentFetchedCoins(error: AppModels.AppError) {
    
  }
}
