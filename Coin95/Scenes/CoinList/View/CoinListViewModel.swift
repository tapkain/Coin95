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
  private var cellHeights = [CGFloat]()
  var coins: Results<Coin>!
  var setup: ((Coin) -> CoinViewModel)!
  
  var count: Int {
    guard let coins = coins else {
      return 0
    }
    return coins.count
  }
  
  func cellState(for index: Int) -> CoinViewModel.CellState {
    return cellHeights[index] == CoinListCell.CellHeight.open ? .open : .closed
  }
  
  func height(for index: Int) -> CGFloat {
    return cellHeights[index]
  }
  
  mutating func toggleCellState(for index: Int) {
    switch cellState(for: index) {
    case .open:
      cellHeights[index] = CoinListCell.CellHeight.close
    case .closed:
      cellHeights[index] = CoinListCell.CellHeight.open
    }
  }
  
  init(coins: Results<Coin>! = nil, setup: ((Coin) -> CoinViewModel)! = nil) {
    self.coins = coins
    self.setup = setup
    cellHeights = calculateCellHeights()
  }
  
  subscript(index: Int) -> CoinViewModel {
    let coin = coins[index]
    var viewModel = setup(coin)
    viewModel.state = cellState(for: index)
    return viewModel
  }
  
  private func calculateCellHeights() -> [CGFloat] {
    return (0..<count).map { _ in CoinListCell.CellHeight.close }
  }
}

struct CoinViewModel {
  enum CellState {
    case open
    case closed
  }
  
  let coinName: String
  let symbol: String
  let imageUrl: URL?
  let history24h: [(x: Double, y: Double)]
  var state: CellState
  let price: String
  
  struct PriceChange {
    let delta: String
    let color: UIColor
  }
}
