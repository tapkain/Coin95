//
//  CoinPricesPresenter.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct CoinListPresenter  {
}


extension CoinListPresenter: CoinListPresentable {
  func present(coins: Coin.FetchResult, _ request: CoinListRequest) -> CoinListViewModel {
    
    let viewModel = CoinListViewModel(
      coins: coins,
      setup: {
        let tradingInfo = $0.tradingInfo(for: request.currency)
        
        return CoinViewModel(
          coinName: $0.name,
          symbol: $0.symbol,
          imageUrl: $0.imageUrl,
          history24h: $0.historicalInfo.map {
            return (x: Double($0.time), y: $0.close)
          },
          price: Formatter.currency.string(from: tradingInfo.price)!
        )
    })
    
    return viewModel
  }
  
  func present(error: AppModels.AppError) {
    
  }
  
  func presentHistory() {
    //view.refreshView()
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
