//
//  CoinPriceCell.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class CoinPriceCell: UITableViewCell {

}


extension CoinPriceCell {
  struct ViewModel {
    let coinImage: UIImage
    let coinName: String
    let ticker: String
    let priceChange: PriceChange
    
    struct PriceChange {
      let delta: String
      let color: UIColor
    }
  }
}
