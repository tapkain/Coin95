//
//  FetchCoinPrices.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/28/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension CryptoCompareApi {
  
  func fetchCoinPrices(for coins: [Coin], with request: CoinPrices.FetchRequest) -> Promise<[Coin]> {
    return fetchCoinPrices(for: coins.map { $0.symbol }, with: request).then {
      self.transform(coinPrices: $0, coins: coins)
    }
  }
  
  private func transform(coinPrices: [String: DataTransferObjects.CoinPrices], coins: [Coin]) -> [Coin] {
    coins.forEach { coin in
      guard let coinPrice = coinPrices[coin.symbol] else {
        return
      }
      
      coinPrice.forEach {
        let price = Price()
        price.currency = $0.key
        price.value = $0.value
        
        coin.prices.append(price)
      }
    }
    
    return coins
  }
  
  private func fetchCoinPrices(with request: CoinPrices.FetchRequest) -> Promise<(String, DataTransferObjects.CoinPrices)> {
    return urlSession.dataTask(with: Endpoints.priceInfo.request(request)).then {
      do {
        let coinPrices = try DataTransferObjects.CoinPrices.decode(from: $0)
        return Promise((request.symbol, coinPrices))
      } catch {
        return Promise((request.symbol, ["USD": 0.0]))
      }
    }
  }
  
  private func fetchCoinPrices(for symbols: [String], with request: CoinPrices.FetchRequest) -> Promise<[String: DataTransferObjects.CoinPrices]> {
    return all(symbols.map {
      self.fetchCoinPrices(with: .init(
        exchange: request.exchange,
        symbol: $0,
        toSymbol: request.toSymbol)
      )
    }).then(transform)
  }
  
  private func transform(coinPrices: [(String, DataTransferObjects.CoinPrices)]) -> [String: DataTransferObjects.CoinPrices] {
    return coinPrices.reduce(into: [:], { data, coinPrice in
      data[coinPrice.0] = coinPrice.1
    })
  }
}


extension CryptoCompareApi.DataTransferObjects {
  typealias CoinPrices = [String: Double]
}
