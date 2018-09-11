//
//  CoinStorage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoCompareAPI

extension Coin: Repository {}


extension WriteTransaction {
  @discardableResult
  func create(coinListItem: CoinListItem, tradingInfo: GetSymbolsFullDataRequest.Response.CurrencyTradingInfo?) -> Coin {
    let coin: Coin = create(primaryKey: coinListItem.symbol)
    setup(coin: coin, from: coinListItem)
    setup(coin: coin, from: tradingInfo)
    return coin
  }
  
  private func setup(coin: Coin, from tradingInfo: GetSymbolsFullDataRequest.Response.CurrencyTradingInfo?) {
    guard let tradingInfo = tradingInfo else {
      return
    }
    
    tradingInfo.forEach {
      let newTradingInfo = create(tradingInfo: $0.value)
      if !coin.tradingInfo.contains(newTradingInfo) {
        coin.tradingInfo.append(newTradingInfo)
      }
    }
  }
  
  private func setup(coin: Coin, from coinListItem: CoinListItem) {
    coin.name = coinListItem.coinName
    coin.imageUrl = coinListItem.imageUrl
  }
}
