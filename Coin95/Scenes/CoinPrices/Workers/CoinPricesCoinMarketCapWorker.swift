//
//  CoinPricesCoinMarketCapWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CoinPricesCoinMarketCapWorker: CoinPricesWorker {

  static let baseUrl = URL(string: "https://api.coinmarketcap.com/v2/")!
  
  func fetchCoins(with request: CoinPrices.FetchRequest, _ completion: @escaping (Result<Coin, AppModels.AppError>) -> Void) {
    URLSession.shared.dataTask(with: buildRequest(from: request)) { data, response, error in
      completion(.success(Coin()))
    }.resume()
  }
  
  private func buildRequest(from request: CoinPrices.FetchRequest) -> URLRequest {
    let queryItems = [URLQueryItem(name: "start", value: String(request.start)), URLQueryItem(name: "limit", value: String(request.limit))]
    let url = CoinPricesCoinMarketCapWorker.baseUrl.appendingPathComponent("ticker")
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    components.queryItems = queryItems
    
    print(components.url!.absoluteString)
    return URLRequest(url: components.url!)
  }
}
