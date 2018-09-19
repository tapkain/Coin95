//
//  CoinPriceCell.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FoldingCell
import SwifterSwift
import Charts

class CoinListCell: FoldingCell {
  struct CellHeight {
    static let close: CGFloat = 85
    static let open: CGFloat = 470
  }
  
  static let identifier = "CoinListCell"
  
  // MARK: - Closed Cell
  @IBOutlet weak var history24hView: LineChartView!
  @IBOutlet weak var leftTopView: UIView!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
  
  // MARK: - Open Cell
  @IBOutlet weak var topView: UIView!
  
  @objc open override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    let durations = [0.33, 0.26, 0.26]
    return durations[itemIndex]
  }
}


extension CoinListCell {
  func bind(to viewModel: CoinViewModel) {
    price.text = viewModel.price
    name.text = viewModel.coinName
    symbol.text = viewModel.symbol
    
    if let imageUrl = viewModel.imageUrl {
      coinImage.kf.setImage(with: imageUrl)
    }
    
    leftTopView.roundCorners([.bottomLeft, .topLeft], radius: 10)
    setupHistoryView(viewModel)
  }
  
  private func setupHistoryView(_ viewModel: CoinViewModel) {
    let dataEntries = viewModel.history24h.map {
      return ChartDataEntry(x: $0.x, y: $0.y)
    }
    
    let dataSet = LineChartDataSet(values: dataEntries, label: nil)
    dataSet.lineWidth = 1
    dataSet.drawValuesEnabled = false
    dataSet.circleRadius = 1
    dataSet.drawCircleHoleEnabled = false
    dataSet.drawFilledEnabled = true
    
    let data = LineChartData(dataSets: [dataSet])
    history24hView.data = data
    history24hView.legend.enabled = false
    history24hView.leftAxis.enabled = false
    history24hView.rightAxis.enabled = false
    history24hView.xAxis.enabled = false
    history24hView.drawGridBackgroundEnabled = false
    history24hView.drawMarkers = false
    history24hView.drawBordersEnabled = false
    history24hView.chartDescription?.enabled = false
    history24hView.isUserInteractionEnabled = false
  }
}
