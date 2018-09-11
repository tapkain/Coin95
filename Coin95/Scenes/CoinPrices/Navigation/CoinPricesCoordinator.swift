//
//  CoinPricesCoordinator.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class CoinPricesCoordinator: Coordinator {
  
  var rootViewController: UINavigationController!
  
  func start() {
    let coinPricesController = UIStoryboard(name: "CoinPrices", bundle: .main).instantiateInitialViewController()
    rootViewController = UINavigationController(rootViewController: coinPricesController!)
    rootViewController.navigationBar.prefersLargeTitles = true
  }
}
