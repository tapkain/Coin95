//
//  CoinPricesViewController.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class CoinPricesViewController: UITableViewController {
  
  private lazy var interactor: CoinPricesBusinessLogic = CoinPricesInteractor(presenter: CoinPricesPresenter(view: self))
  
  private var viewModel = CoinPrices.ViewModel(coins: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    view.backgroundColor = .red
    interactor.fetchCoins(with: CoinPrices.FetchRequest(source: .coinMarketCap))
  }
  
  func initTableView() {
    //tableView.register(CoinPriceCell.self, forCellReuseIdentifier: CoinPriceCell.identifier)
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
    return viewModel.coins.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CoinPriceCell.identifier, for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? CoinPriceCell else {
      return
    }
    
    cell.bind(to: viewModel.coins[indexPath.row])
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}
