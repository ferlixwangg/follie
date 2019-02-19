//
//  Difficulty.swift
//  cubeRun
//
//  Created by Steven Muliamin on 19/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

class Difficulty {
    init(maxInterval: Int, maxHoldNum: Int, maxHoldBeat: Int, holdChance: Double) {
        self.maxInterval = maxInterval
        self.maxHoldNum = maxHoldNum
        self.maxHoldBeat = maxHoldBeat
        self.holdChance = holdChance
    }
    
    var maxInterval: Int // max beat interval between blocks
    var maxHoldNum: Int // max number of connecting lines between blocks (hold gesture)
    var maxHoldBeat: Int // max number of beats in one hold gesture between 2 blocks
    var holdChance: Double // percentage of connecting blocks appearing
}
