//
//  CoinCapWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension CoinCap {
  
  struct Worker: CoinPricesWorker {
    static let baseUrl = URL(string: "http://coincap.io/history/")!
    
    func fetchCoins(with request: CoinPrices.FetchRequest) -> Promise<[CoinPrice]> {
      return Promise([])
    }
    
    func fetchHistory(with request: CoinPrices.FetchRequest) -> Promise<[Point]> {
      return URLSession.shared.dataTask(with: buildHistoryRequest(from: request)).then {
        let history = try CoinCap.History.decode(from: $0)
        var iterator = history.price.flatMap { $0 }.makeIterator()
        var points = [Point]()
        
        while let first = iterator.next() {
          if let second = iterator.next() {
            points.append(Point.make(x: first, y: second))
          }
        }
        
        return Promise(points)
      }
    }
    
    func buildHistoryRequest(from request: CoinPrices.FetchRequest) -> URLRequest {
      let url = Worker.baseUrl.appendingPathComponent("\(request.historyPeriod)day").appendingPathComponent(request.symbol)
      print(url.absoluteString)
      
      return URLRequest(url: url)
    }
  }
}
