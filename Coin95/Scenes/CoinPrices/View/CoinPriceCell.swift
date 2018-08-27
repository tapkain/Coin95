//
//  CoinPriceCell.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CoinPriceCell: UITableViewCell {
  //static let identifier = String(describing: self)
  static let identifier = "CoinPriceCell"
  
  @IBOutlet weak var priceChart: LineChartView!
  @IBOutlet weak var priceChange: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
}


extension CoinPriceCell {
  func bind(to viewModel: CoinPrices.CoinViewModel) {
    priceChange.text = viewModel.priceChange.delta
    priceChange.backgroundColor = viewModel.priceChange.color
    price.text = viewModel.price
    symbol.text = viewModel.symbol
    name.text = viewModel.coinName
    
    priceChart.drawBordersEnabled = false
    priceChart.drawGridBackgroundEnabled = false
    priceChart.legend.enabled = false
    priceChart.leftAxis.enabled = false
    priceChart.xAxis.enabled = false
    priceChart.isUserInteractionEnabled = false
    priceChart.chartDescription = nil
    
    priceChart.data = viewModel.priceChartData
  }
}
