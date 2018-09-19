//
//  Segmentio+Theme.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Segmentio

extension Segmentio {
  static var defaultOptions: SegmentioOptions = {
    let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1.2, height: 3, color: .aquaLight)
    
    let states = SegmentioStates(
      defaultState: SegmentioState(
        backgroundColor: .clear,
        titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: .white
      ),
      selectedState: SegmentioState(
        backgroundColor: .clear,
        titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: .aquaLight
      ),
      highlightedState: SegmentioState(
        backgroundColor: .platinum,
        titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: .black
      )
    )
    
    let horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 1, color: .platinum)
    
    let options = SegmentioOptions(
      backgroundColor: .yankeesBlue,
      segmentPosition: .dynamic,
      scrollEnabled: true,
      indicatorOptions: indicatorOptions,
      horizontalSeparatorOptions: horizontalSeparatorOptions,
      verticalSeparatorOptions: nil,
      imageContentMode: .center,
      labelTextAlignment: .center,
      labelTextNumberOfLines: 1,
      segmentStates: states,
      animationDuration: 0.2
    )
    
    return options
  }()
}
