//
//  PersistentObject.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

protocol PersistentObject: class {
}

extension Object: PersistentObject {
}
