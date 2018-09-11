//
//  CoinPricesPresenter.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

struct CoinPricesPresenter {

  private let view: CoinPricesView
  
  init(view: CoinPricesView) {
    self.view = view
  }
}


extension CoinPricesPresenter: CoinPricesPresentable {
  
  func presentFetchedCoins(for response: CoinPrices.Response) {
    let viewModel = CoinPrices.ViewModel(
      coins: response.coins,
      setup: {
        CoinPrices.CoinViewModel(
          coinName: $0.name,
          imageUrl: $0.imageUrl,
          symbol: $0.symbol,
          price: "zalypa",
          priceChartData: ChartData(),
          priceChange: CoinPrices.CoinViewModel.PriceChange(
            delta: "",
            color: .white
          )
        )
    })
    
    self.view.displayFetchedCoins(with: viewModel)
  }
  
  func presentFetchedCoins(error: AppModels.AppError) {
    
  }
  
//  private func priceChartData(for points: List<Point>) -> ChartData {
//    let dataSet = LineChartDataSet(values: points.map(pointToChartEntry), label: nil)
//    dataSet.drawCirclesEnabled = false
//    dataSet.lineWidth = 2
//    dataSet.drawFilledEnabled = true
//
//    return LineChartData(dataSet: dataSet)
//  }
//
//  private func pointToChartEntry(_ point: Point) -> ChartDataEntry {
//    return ChartDataEntry(x: point.x, y: point.y)
//  }
  
  private func color(for priceChange: Double) -> UIColor {
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
