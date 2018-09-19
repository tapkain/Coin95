//
//  NVActivityIndicatorView+Random.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import NVActivityIndicatorView

extension NVActivityIndicatorView {
  func setRandomType() {
    let randomInt = Int(arc4random_uniform(UInt32(NVActivityIndicatorType.audioEqualizer.rawValue)) + 1)
    type = NVActivityIndicatorType(rawValue: randomInt)!
  }
}
