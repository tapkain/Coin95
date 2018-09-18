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
import SkeletonView

class CoinListCell: UITableViewCell {
  //static let identifier = String(describing: self)
  static let identifier = "CoinListCell"
  
  @IBOutlet weak var priceChange7d: UILabel!
  @IBOutlet weak var priceChange24h: UILabel!
  @IBOutlet weak var priceChange1h: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var symbol: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var coinImage: UIImageView!
}


extension CoinListCell {
  func bind(to viewModel: CoinViewModel) {
    priceChange1h.text = viewModel.priceChange1h.delta
    priceChange1h.textColor = viewModel.priceChange1h.color
    
    priceChange24h.text = viewModel.priceChange24h.delta
    priceChange24h.textColor = viewModel.priceChange24h.color
    
    priceChange7d.text = viewModel.priceChange7d.delta
    priceChange7d.textColor = viewModel.priceChange7d.color
    
    price.text = viewModel.price
    symbol.text = viewModel.symbol
    name.text = viewModel.coinName
    
    if let imageUrl = viewModel.imageUrl {
      coinImage.kf.setImage(with: imageUrl)
    }
    
    prepareForSkeleton(false)
  }
  
  func prepareForSkeleton(_ isHidden: Bool = true) {
    price.isHidden = isHidden
    priceChange1h.isHidden = isHidden
    priceChange24h.isHidden = isHidden
    priceChange7d.isHidden = isHidden
    name.isHidden = isHidden
  }
}
