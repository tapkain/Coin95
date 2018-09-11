//
//  CoinPricesCoordinator.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class CoinListCoordinator: Coordinator {
  var rootViewController: UINavigationController!
  
  func start() {
    let coinListController = UIStoryboard(name: "CoinList", bundle: .main).instantiateInitialViewController() as! CoinListViewController
    
    let presenter = CoinListPresenter(view: coinListController)
    let useCase = CoinListInteractor(presenter: presenter)
    coinListController.useCase = useCase
    
    rootViewController = UINavigationController(rootViewController: coinListController)
    rootViewController.navigationBar.prefersLargeTitles = true
  }
}
