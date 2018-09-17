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
import Kingfisher
import SkeletonView

class CoinListCell: UITableViewCell {
  //static let identifier = String(describing: self)
  static let identifier = "CoinListCell"
  
  @IBOutlet weak var priceChart: LineChartView!
  @IBOutlet weak var priceChange: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
}


extension CoinListCell {
  func bind(to viewModel: CoinViewModel) {
    priceChange.text = viewModel.priceChange.delta
    priceChange.backgroundColor = viewModel.priceChange.color
    price.text = viewModel.price
    symbol.text = viewModel.symbol
    name.text = viewModel.coinName
    
    if let imageUrl = viewModel.imageUrl {
      coinImage.kf.setImage(with: imageUrl)
    }
    
    price.isHidden = false
    priceChange.isHidden = false
    name.isHidden = false
  }
}
