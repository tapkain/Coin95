//
//  CoinMarketCapWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension CoinMarketCap {
  
  struct Worker: CoinPricesWorker {
    static let baseUrl = URL(string: "https://api.coinmarketcap.com/v2/")!
    
    func fetchCoins(with request: CoinPrices.FetchRequest) -> Promise<[CoinPrice]> {
      return fetchCoinPrices(with: request).then {
        return all($0.map { self.fetchHistory(for: $0)} )
      }
    }
    
    private func fetchCoinPrices(with request: CoinPrices.FetchRequest) -> Promise<[CoinPrice]> {
      return URLSession.shared.dataTask(with: buildRequest(from: request)).then {
        let tickers = try CoinMarketCap.Tickers.decode(from: $0)
        var coinPrices = [CoinPrice]()
        
        for (_, ticker) in tickers.data {
          coinPrices.append(CoinPrice(from: ticker))
        }
        
        return Promise(coinPrices)
      }
    }
    
    private func fetchHistory(for coin: CoinPrice) -> Promise<CoinPrice> {
      let request = CoinPrices.FetchRequest(symbol: coin.symbol)
      
      return CoinCap.Worker().fetchHistory(with: request).then {
        coin.pricePoints.removeAll()
        coin.pricePoints.append(objectsIn: $0)
        return Promise(coin)
      }
    }
    
    private func buildRequest(from request: CoinPrices.FetchRequest) -> URLRequest {
      let queryItems = [URLQueryItem(name: "start", value: String(request.start)), URLQueryItem(name: "limit", value: String(request.limit))]
      let url = Worker.baseUrl.appendingPathComponent("ticker")
      var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
      components.queryItems = queryItems
      
      print(components.url!.absoluteString)
      return URLRequest(url: components.url!)
    }
  }
}
