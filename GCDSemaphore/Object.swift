//
//  Object.swift
//  GCDSemaphore
//
//  Created by 楊雅涵 on 2019/8/22.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import Foundation


struct SpeedLocate: Codable {
    var speed_limit: String
    var road: String
}

struct DataGroup: Codable {
    var results: [SpeedLocate]
  
}

struct Data: Codable {
    var result: DataGroup
}
