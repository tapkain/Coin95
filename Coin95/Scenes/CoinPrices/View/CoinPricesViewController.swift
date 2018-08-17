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
  
  private var viewModel = CoinPrices.ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    interactor.fetchCoins(with: CoinPrices.FetchRequest(source: .coinMarketCap))
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
    return 30
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: "CoinPriceCell", for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}
