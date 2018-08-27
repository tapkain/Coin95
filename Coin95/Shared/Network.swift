//
//  Network.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension URLSession {
  func dataTask(with request: URLRequest) -> Promise<Data> {
    return Promise { fulfill, reject in
      self.dataTask(with: request) { data, response, error in
        var validationError = error
        let result = Network.validate(data, response, &validationError)
        
        if let error = validationError {
          reject(error)
          return
        }
        
        fulfill(result)
      }.resume()
    }
  }
}

struct Network {
  static func validate(_ data: Data?, _ response: URLResponse?, _ error: inout Error?) -> Data {
    if let _ = error {
      error = AppModels.AppError.requestError
      return Data()
    }
    
    if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
      error = AppModels.AppError.requestError
      return Data()
    }
    
    guard let data = data else {
      error = AppModels.AppError.noData
      return Data()
    }
    
    return data
  }
}


extension Decodable {
  static func decode(from data: Data) throws -> Self {
    do {
      return try JSONDecoder().decode(Self.self, from: data)
    } catch {
      throw AppModels.AppError.badData
    }
  }
}
