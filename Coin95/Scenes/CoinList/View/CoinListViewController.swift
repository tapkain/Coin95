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

class CoinListViewController: UITableViewController, ViewController {
  typealias ViewModel = CoinListViewModel
  
  enum State {
    case fullFetch
    case lazyFetch
    case displayingCoins
  }
  
  var useCase: CoinListUseCase!
  private var viewModel = ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.showAnimatedGradientSkeleton()
    title = "All Coins"
    
    let request = CoinListRequest(
      fromSymbol: "BTC",
      toSymbol: "USD",
      exchange: "CCCAGG"
    )
    
    _ = useCase.fetchCoins(request).then {
      self.view.hideSkeleton()
    }
  }
}


extension CoinListViewController: CoinListView {
  func displayFetchedCoins(with viewModel: ViewModel) {
    self.viewModel = viewModel
    tableView.reloadData()
  }
  
  func display(error: AppModels.AppError) {
    
  }
  
  func refreshView() {
    tableView.reloadData()
  }
}


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


extension CoinListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return CoinListCell.identifier
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
}
