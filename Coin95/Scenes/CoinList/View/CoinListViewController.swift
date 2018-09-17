//
//  CoinPricesViewController.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import RealmSwift
import SkeletonView
import SwifterSwift

class CoinListViewController: UITableViewController, ViewController {
  typealias ViewModel = CoinListViewModel
  
  enum ViewState {
    case loading
    case displayingCoins
    case filtering
    case emptyData
  }
  
  var useCase: CoinListUseCase!
  private var useCaseRequest = CoinListRequest.initial
  private var viewModel = ViewModel()
  private var state = ViewState.emptyData
  
  private var searchController: UISearchController {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.obscuresBackgroundDuringPresentation = false
    controller.searchBar.placeholder = "Search by name or symbol"
    navigationItem.searchController = controller
    definesPresentationContext = true
    return controller
  }
  
  private var rightBarButtonItems: [UIBarButtonItem] {
    return [
      UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchBar))
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCoins()
    title = "All Coins"
    navigationItem.rightBarButtonItems = rightBarButtonItems
  }
  
  func fetchCoins() {
    state = .loading
    view.showAnimatedGradientSkeleton()
    useCase.fetchCoins(useCaseRequest).then { viewModel in
      DispatchQueue.main.async {
        self.viewModel = viewModel
        self.tableView.reloadData()
        self.view.hideSkeleton(reloadDataAfter: false)
      }
    }
  }
}


// MARK: - CoinListView
extension CoinListViewController {
  func displayFetchedCoins(with viewModel: ViewModel) {
    self.viewModel = viewModel
    tableView.reloadData() {
      if viewModel.count != 0 {
        let path = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: path, at: .top, animated: true)
      }
    }
  }
  
  func display(error: AppModels.AppError) {
    
  }
  
  func refreshView() {
    tableView.reloadData()
  }
}


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
    
    guard let result = viewModel.coins else {
      return
    }
    
    let coin = result[indexPath.row]
    let cellViewModel = viewModel.setup(coin)
    cell.bind(to: cellViewModel)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}


// MARK: - SkeletonTableViewDataSource
extension CoinListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return CoinListCell.identifier
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count != 0 ? viewModel.count : 30
  }
}


// MARK: - UISearchControllerDelegate
extension CoinListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text ?? ""
    useCaseRequest.searchBy = .name(text)
    fetchCoins()
  }
}


// MARK: - Actions
extension CoinListViewController {
  @objc func openSearchBar() {
    searchController.show(self, sender: self)
  }
}
