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
      cell.willDisplay(with: viewModel[indexPath.row])
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.height(for: indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case let cell as CoinListCell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    if cell.isAnimating() {
      return
    }
    
    var duration = 0.0
    if viewModel.cellState(for: indexPath.row) == .closed {
      duration = 0.5
    } else {
      duration = 0.8
    }
    
    viewModel.toggleCellState(for: indexPath.row)
    cell.didSelected(with: viewModel[indexPath.row])
    cell.historySegmentControl.valueDidChange = { [unowned self] _, index in
      let coin = self.viewModel.coins[indexPath.row]
      self.useCase.fetchHistory(for: coin, self.useCaseRequest)
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
      tableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
