//
//  CoinPricesPresenter.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

struct CoinPricesPresenter {

  private let view: CoinPricesView
  
  init(view: CoinPricesView) {
    self.view = view
  }
}


extension CoinPricesPresenter: CoinPricesPresentable {
  
  func presentFetchedCoins(for response: CoinPrices.Response) {
    let viewModel = CoinPrices.ViewModel(
      coins: response.coins.map {
        CoinPrices.CoinViewModel(
          coinImage: UIImage(named: "Zalypa"),
          coinName: $0.name,
          symbol: $0.symbol,
          price: String($0.price),
          priceChange: CoinPrices.CoinViewModel.PriceChange(
            delta: String($0.priceChange),
            color: color(for: $0.priceChange)
          )
        )
      }
    )
    
    DispatchQueue.main.async {
      self.view.displayFetchedCoins(with: viewModel)
    }
  }
  
  func presentFetchedCoins(error: AppModels.AppError) {
    
  }
  
  func color(for priceChange: Double) -> UIColor {
    switch priceChange {
    case 1...:
      return .green
      
    case ..<0:
      return .red
      
    default:
      return .yellow
    }
  }
}
