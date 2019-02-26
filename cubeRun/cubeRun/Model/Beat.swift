//
//  Beat.swift
//  cubeRun
//
//  Created by Steven Muliamin on 19/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

class Beat {
    var nthLine: Int // where the beat lies from lines 1-5 (bottom to top)
    var nextBeatIn: Double  // duration until next beat (multiplier of music's bpm)
    // eg. value = 0.5, secPerBeat = 0.8, means next beat comes in (0.8 * 0.5) = 0.4 seconds
    var connectToNext: Bool // if beat is connected to next beat
    
    init(nthLine: Int, nextBeatIn: Double, connectToNext: Bool) {
        self.nthLine = nthLine
        self.nextBeatIn = nextBeatIn
        self.connectToNext = connectToNext
    }
}
