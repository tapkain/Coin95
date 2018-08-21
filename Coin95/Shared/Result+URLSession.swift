//
//  Result+URLSession.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Result

extension Result where Value: Decodable, Error == AppModels.AppError {
  init(_ data: Data?, _ response: URLResponse?, _ error: Swift.Error?) {
    if let _ = error {
      self = .failure(.requestError)
      return
    }
    
    if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
      self = .failure(.requestError)
      return
    }
    
    guard let data = data else {
      self = .failure(.noData)
      return
    }
    
    do {
      let result = try JSONDecoder().decode(Value.self, from: data)
      self = .success(result)
    } catch {
      self = .failure(.badData)
    }
  }
}
