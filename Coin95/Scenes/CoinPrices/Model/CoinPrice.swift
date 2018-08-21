//
//  Coin.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

protocol CoinPrice {
  init()
  
  var name: String { get set }
  var symbol: String { get set }
  var price: Double { get set }
  var priceChange: Double { get set }
}
