//
//  CoinPricesViewController.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import RealmSwift

class CoinPricesViewController: UITableViewController {
  
  enum State {
    case fullFetch
    case lazyFetch
    case displayingCoins
  }
  
  private lazy var interactor: CoinPricesBusinessLogic = CoinPricesInteractor(presenter: CoinPricesPresenter(view: self))
  
  private var viewModel = CoinPrices.ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "All Coins"
    interactor.fetchCoins(with: CoinPrices.FetchRequest.initial)
  }
}


extension CoinPricesViewController: CoinPricesView {
  func displayFetchedCoins(with viewModel: CoinPrices.ViewModel) {
    self.viewModel = viewModel
    tableView.reloadData()
  }
  
  func display(error: AppModels.AppError) {
    
  }
}


extension CoinPricesViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CoinPriceCell.identifier, for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? CoinPriceCell else {
      return
    }
    
    let coin = viewModel.coins[indexPath.row]
    let cellViewModel = viewModel.setup(coin)
    
    cell.bind(to: cellViewModel)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}
