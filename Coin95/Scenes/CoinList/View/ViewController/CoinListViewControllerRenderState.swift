//
//  CoinListViewControllerRenderState.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

extension CoinListViewController {
  func render() {
    switch state {
    case .fetching:
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      loadingIndicator.isHidden = false
      loadingIndicator.play()
      
    case .fetched(let viewModel):
      displayFetchedCoins(with: viewModel)
      
    case .emptyData:
      emptyDataView.isHidden = false
    }
  }
  
  func displayFetchedCoins(with viewModel: ViewModel) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    self.viewModel = viewModel
    
    tableView.reloadData() {
      if viewModel.count != 0 {
        self.emptyDataView.isHidden = true
        let path = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: path, at: .top, animated: true)
      } else {
        self.state = .emptyData
      }
    }
  }
  
  func display(error: AppModels.AppError) {
    
  }
}
