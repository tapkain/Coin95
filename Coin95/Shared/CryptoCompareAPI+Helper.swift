//
//  CryptoCompareAPI+Helper.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/6/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises
import CryptoCompareAPI

extension CryptoCompareAPI {
  func send<T: APIRequest>(_ request: T) -> Promise<T.Response> {
    return Promise { fulfill, reject in
      self.send(request) {
        switch $0 {
        case .success(let value):
          fulfill(value)
          
        case .failure(let error):
          reject(error)
        }
      }
    }
  }
}
