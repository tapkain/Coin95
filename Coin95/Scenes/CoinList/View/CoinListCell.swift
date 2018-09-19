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

class CoinListCell: FoldingCell {
  struct CellHeight {
    static let close: CGFloat = 85
    static let open: CGFloat = 456
  }
  
  static func cellHeights(_ cellCount: Int) -> [CGFloat] {
    return (0..<cellCount).map { _ in CellHeight.close }
  }
  
  //static let identifier = String(describing: self)
  static let identifier = "CoinListCell"
  
  @IBOutlet weak var leftTopView: UIView!
  @IBOutlet weak var priceChange7d: UILabel!
  @IBOutlet weak var priceChange24h: UILabel!
  @IBOutlet weak var priceChange1h: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
  
  @objc open override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    let durations = [0.33, 0.26, 0.26] // timing animation for each view
    return durations[itemIndex]
  }
}


extension CoinListCell {
  func bind(to viewModel: CoinViewModel) {
//    priceChange1h.text = viewModel.priceChange1h.delta
//    priceChange1h.textColor = viewModel.priceChange1h.color
//
//    priceChange24h.text = viewModel.priceChange24h.delta
//    priceChange24h.textColor = viewModel.priceChange24h.color
//
//    priceChange7d.text = viewModel.priceChange7d.delta
//    priceChange7d.textColor = viewModel.priceChange7d.color
    
    price.text = viewModel.price
//    symbol.text = viewModel.symbol
    name.text = viewModel.coinName
//
    if let imageUrl = viewModel.imageUrl {
      coinImage.kf.setImage(with: imageUrl)
    }
    
    leftTopView.roundCorners([.bottomLeft, .topLeft], radius: 10)
  }
}
