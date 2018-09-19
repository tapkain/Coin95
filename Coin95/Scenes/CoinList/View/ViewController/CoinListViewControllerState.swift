//
//  CoinListViewControllerState.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

extension CoinListViewController {
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
}
