//
//  SettingsCoordinator.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinator {
  
  var rootViewController: UINavigationController!
  
  func start() {
    let settingsViewController = SettingsViewController()
    rootViewController = UINavigationController(rootViewController: settingsViewController)
  }
}
