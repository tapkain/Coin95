//
//  CoinPricesInteractor.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Reachability
import RealmSwift //REMOVE

struct CoinPricesInteractor {

  private let worker: CoinPricesWorker = CoinPrices.Worker()
  private let presenter: CoinPricesPresentable
  
  init(presenter: CoinPricesPresentable) {
    self.presenter = presenter
  }
}


extension CoinPricesInteractor: CoinPricesBusinessLogic {
  
  func fetchCoins(with request: CoinPrices.FetchRequest) {
    if shouldFetchFromAPI() {
      fetchFromAPI(with: request)
    } else {
      fetchFromLocalStorage(with: request)
    }
  }
  
  private func fetchFromAPI(with request: CoinPrices.FetchRequest) {
    worker.fetchCoins(with: request).then {_ in
      self.fetchFromLocalStorage(with: request)
    }.catch {
      self.handle(error: $0)
    }
  }
  
  private func shouldFetchFromAPI() -> Bool {
    return Reachability.forInternetConnection().isReachable()
  }
  
  private func fetchFromLocalStorage(with request: CoinPrices.FetchRequest) {
    //TODO: workaround
    DispatchQueue.main.async {
      let realm = try! Realm()
      let coins = realm.objects(Coin.self)
      let response = CoinPrices.Response(coins: coins)
      self.presenter.presentFetchedCoins(for: response)
    }
  }
  
  private func handle(error: Error) {
    print(error.localizedDescription)
  }
}
