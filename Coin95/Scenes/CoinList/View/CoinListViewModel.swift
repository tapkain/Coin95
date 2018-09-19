//
//  ViewModel.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

struct CoinListViewModel {
  var cellHeights = [CGFloat]()
  var coins: Results<Coin>!
  var setup: ((Coin) -> CoinViewModel)!
  
  var count: Int {
    guard let coins = coins else {
      return 0
    }
    return coins.count
  }
  
  init(coins: Results<Coin>! = nil, setup: ((Coin) -> CoinViewModel)! = nil) {
    self.coins = coins
    self.setup = setup
    cellHeights = calculateCellHeights()
  }
  
  private func calculateCellHeights() -> [CGFloat] {
    return (0..<count).map { _ in CoinListCell.CellHeight.close }
  }
}

struct CoinViewModel {
  let coinName: String
  let symbol: String
  let imageUrl: URL?
  let history24h: [(x: Double, y: Double)]
  let price: String
  
  struct PriceChange {
    let delta: String
    let color: UIColor
  }
}
