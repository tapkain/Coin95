//
//  Result.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum Result<Value, Error> {
  case success(Value)
  case error(Error)
}
