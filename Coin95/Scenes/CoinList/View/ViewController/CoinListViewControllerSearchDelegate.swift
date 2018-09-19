//
//  CoinListViewControllerSearchDelegate.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UISearchControllerDelegate
extension CoinListViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    searchTimer?.invalidate()
    guard let text = searchController.searchBar.text, !text.isEmpty && !state.isFetching else {
      return
    }
    
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
      self.useCaseRequest.searchBy = .name(text)
      self.fetchCoins()
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    useCaseRequest.searchBy = .none
    fetchCoins()
  }
}
