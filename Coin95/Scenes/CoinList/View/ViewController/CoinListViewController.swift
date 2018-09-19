//
//  CoinPricesViewController.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie
import SwifterSwift

class CoinListViewController: UITableViewController, ViewController {
  typealias ViewModel = CoinListViewModel
  
  var useCase: CoinListUseCase!
  var useCaseRequest = CoinListRequest.initial
  var viewModel = ViewModel()
  var searchTimer: Timer?
  
  var state = ViewState.emptyData {
    didSet {
      print("State changed from \(oldValue.description) to \(state.description)")
      DispatchQueue.main.async {
        self.render()
      }
    }
  }
  
  lazy var loadingIndicator: LOTAnimationView = {
    let view = LOTAnimationView(name: "loadingIndicator")
    view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin]
    view.contentMode = .scaleAspectFit
    view.loopAnimation = true
    self.view.addSubview(view)
    return view
  }()
  
  lazy var emptyDataView: UIView = {
    let nib = UINib(nibName: "CoinListEmptyTableView", bundle: Bundle.main)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    view.isHidden = true
    view.frame = tableView.frame
    self.view.addSubview(view)
    return view
  }()
  
  var searchController: UISearchController {
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
  
  var rightBarButtonItems: [UIBarButtonItem] {
    return [
    ]
  }
  
  lazy var pullToRefresh: UIRefreshControl = {
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(fetchCoins), for: .valueChanged)
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCoins()
    view.backgroundColor = .black
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
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stop()
      }
    }
  }
}

