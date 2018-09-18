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
  
  enum ViewState: CustomStringConvertible {
    case fetching
    case fetched(ViewModel)
    case emptyData
    
    var isEmptyData: Bool {
      switch self {
      case .emptyData:
        return true
      default:
        return false
      }
    }
    
    var isFetching: Bool {
      switch self {
      case .fetching:
        return true
      default:
        return false
      }
    }
    
    var description: String {
      switch self {
      case .fetching:
        return "Fetching"
      case .fetched(_):
        return "Fetched"
      case .emptyData:
        return "Empty Data"
      }
    }
  }
  
  var useCase: CoinListUseCase!
  private var useCaseRequest = CoinListRequest.initial
  private var viewModel = ViewModel()
  private var searchTimer: Timer?
  
  private var state = ViewState.emptyData {
    didSet {
      print("State changed from \(oldValue.description) to \(state.description)")
      DispatchQueue.main.async {
        self.render()
      }
    }
  }
  
  private var searchController: UISearchController {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.obscuresBackgroundDuringPresentation = false
    controller.searchBar.placeholder = "Search by name or symbol"
    controller.searchBar.delegate = self
    
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
    state = .fetching
    useCase.fetchCoins(useCaseRequest).then { viewModel in
      self.state = .fetched(viewModel)
    }
  }
  
  func render() {
    switch state {
    case .fetching:
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      view.showAnimatedGradientSkeleton()
      
    case .fetched(let viewModel):
      displayFetchedCoins(with: viewModel)

    case .emptyData:
      print("Empty Data")
    }
  }
}


// MARK: - CoinListView
extension CoinListViewController {
  func displayFetchedCoins(with viewModel: ViewModel) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    self.viewModel = viewModel
    
    DispatchQueue.main.async {
      self.view.hideSkeleton(reloadDataAfter: false)
    }
    
    tableView.reloadData() {
      if viewModel.count != 0 {
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
      cell.prepareForSkeleton()
      
    default:
      let coin = viewModel.coins[indexPath.row]
      let cellViewModel = viewModel.setup(coin)
      cell.bind(to: cellViewModel)
    }
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
    return state.isFetching ? 30 : viewModel.count
  }
}


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


// MARK: - Actions
extension CoinListViewController {
  @objc func openSearchBar() {
    searchController.show(self, sender: self)
  }
}
