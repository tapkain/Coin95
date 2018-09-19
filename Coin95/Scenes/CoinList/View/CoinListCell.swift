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
import Segmentio

class CoinListCell: FoldingCell {
  enum ViewState {
    case closed
    case open
  }
  
  var state = ViewState.closed
  
  struct CellHeight {
    static let close: CGFloat = 85
    static let open: CGFloat = 470
  }
  
  static let identifier = "CoinListCell"
  static let segmentItems = [
    SegmentioItem(title: "1H", image: nil),
    SegmentioItem(title: "24H", image: nil),
    SegmentioItem(title: "7D", image: nil),
    SegmentioItem(title: "1M", image: nil),
    SegmentioItem(title: "3M", image: nil),
    SegmentioItem(title: "1Y", image: nil),
    SegmentioItem(title: "ALL", image: nil),
  ]
  
  // MARK: - Closed Cell
  @IBOutlet weak var history24hView: LineChartView!
  @IBOutlet weak var leftTopView: UIView!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
  
  // MARK: - Open Cell
  @IBOutlet weak var historySegmentControl: Segmentio!
  
  @objc open override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    let durations = [0.33, 0.26, 0.26]
    return durations[itemIndex]
  }
}


extension CoinListCell {
  func setupOpenCell(with viewModel: CoinViewModel) {
    historySegmentControl.setup(
      content: CoinListCell.segmentItems,
      style: .onlyLabel,
      options: Segmentio.defaultOptions
    )
    
    historySegmentControl.valueDidChange = { _, _ in
      //fetch from use case data and display
    }
    
    historySegmentControl.selectedSegmentioIndex = 1
  }
  
  func setupCloseCell(with viewModel: CoinViewModel) {
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
