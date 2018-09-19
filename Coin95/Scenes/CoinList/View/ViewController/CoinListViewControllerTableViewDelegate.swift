//
//  CoinListViewControllerTableViewDelegate.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell

// MARK: - UITableViewDataSource
extension CoinListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? CoinListCell else {
      return
    }
    
    switch state {
    case .emptyData, .fetching:
      return
      
    default:
      let coin = viewModel.coins[indexPath.row]
      let cellViewModel = viewModel.setup(coin)
      cell.setupCloseCell(with: cellViewModel)
      //cell.bind(to: cellViewModel)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.cellHeights[indexPath.row]
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    var duration = 0.0
    if viewModel.cellHeights[indexPath.row] == CoinListCell.CellHeight.close {
      viewModel.cellHeights[indexPath.row] = CoinListCell.CellHeight.open
      cell.unfold(true, animated: true, completion: nil)
      duration = 0.5
    } else {
      viewModel.cellHeights[indexPath.row] = CoinListCell.CellHeight.close
      cell.unfold(false, animated: true, completion: nil)
      duration = 0.8
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
      tableView.beginUpdates()
      tableView.endUpdates()
    })
  }
}


// MARK: - UITableViewPrefetchDataSource
extension CoinListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      let coin = viewModel.coins[$0.row]
      useCase.fetchHistory(for: coin, useCaseRequest)
    }
  }
}
