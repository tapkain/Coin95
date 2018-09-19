//
//  CoinPricesViewController.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView
import SwifterSwift
import FoldingCell

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
  
  private lazy var activityIndicator: NVActivityIndicatorView = {
    let view = NVActivityIndicatorView(
      frame: .zero,
      type: .ballPulseSync,
      color: .purple
    )
    
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    
    NSLayoutConstraint.activate([
        view.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        view.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -150),
        view.widthAnchor.constraint(equalToConstant: 75),
        view.heightAnchor.constraint(equalToConstant: 75)
    ])
    
    return view
  }()
  
  private lazy var emptyDataView: UIView = {
    let nib = UINib(nibName: "CoinListEmptyTableView", bundle: Bundle.main)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    view.isHidden = true
    view.frame = tableView.frame
    self.view.addSubview(view)
    return view
  }()
  
  private var searchController: UISearchController {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.obscuresBackgroundDuringPresentation = false
    controller.searchBar.placeholder = "Search coin"
    controller.searchBar.delegate = self
    
    navigationItem.searchController = controller
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
    return controller
  }
  
  private var rightBarButtonItems: [UIBarButtonItem] {
    return [
      UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchBar))
    ]
  }
  
  private lazy var pullToRefresh: UIRefreshControl = {
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(fetchCoins), for: .valueChanged)
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCoins()
    title = "All Coins"
    navigationItem.rightBarButtonItems = rightBarButtonItems
    tableView.refreshControl = pullToRefresh
    tableView.prefetchDataSource = self
    searchController.isActive = true
  }
  
  @objc func fetchCoins() {
    state = .fetching
    useCase.fetchCoins(useCaseRequest).then { viewModel in
      self.state = .fetched(viewModel)
    }.always {
      // TODO: Move this to state handling when implementing errors
      DispatchQueue.main.async {
        self.pullToRefresh.endRefreshing()
      }
    }
  }
  
  func render() {
    switch state {
    case .fetching:
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      activityIndicator.setRandomType()
      activityIndicator.startAnimating()
      
    case .fetched(let viewModel):
      displayFetchedCoins(with: viewModel)

    case .emptyData:
      emptyDataView.isHidden = false
    }
  }
}


// MARK: - CoinListView
extension CoinListViewController {
  func displayFetchedCoins(with viewModel: ViewModel) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    self.viewModel = viewModel
    self.activityIndicator.stopAnimating()
    
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
      cell.bind(to: cellViewModel)
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
    print("prefetchRowsAt \(indexPaths)")
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    print("cancelPrefetchingForRowsAt \(indexPaths)")
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
