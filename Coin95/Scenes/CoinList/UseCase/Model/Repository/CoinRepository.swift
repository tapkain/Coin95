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

extension Coin: Repository {
  static func fetchAll(for filter: CoinListRequest) -> FetchResult {
    let realm = try! Realm()
    
    let info = realm.objects(TradingInfo.self)
      .filter("totalVolume != 0")
      .filter("exchangeString == %@", filter.exchange)
      .sorted(byKeyPath: filter.sortBy.rawValue)
    
    let coins = realm.objects(Coin.self)
      .filter("tradingInfo.@count > 0")
      .filter("symbol in %@", info.value(forKeyPath: "coin.symbol")!)
    
    switch filter.searchBy {
    case .name(let value):
      return coins.filter("symbol CONTAINS[cd] %@ || name CONTAINS[cd] %@", value, value)
    default:
      return coins
    }
    
    fatalError()
  }
  
  func tradingInfo(for currency: String) -> TradingInfo {
    return tradingInfo.first(where: { $0.currency == currency })!
  }
}


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
      newTradingInfo.coin = coin
    }
  }
  
  private func setup(coin: Coin, from coinListItem: CoinListItem) {
    coin.name = coinListItem.coinName
    coin.imageUrl = coinListItem.imageUrl
  }
}
