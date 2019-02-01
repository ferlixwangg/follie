//
//  Music.swift
//  cubeRun
//
//  Created by Steven Muliamin on 25/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains all music file names used in the project
class Music {
    var name: String // music filename
    var secPerBeat: Double // the time (seconds) it takes between beats
    
    init(name: String, secPerBeat: Double) {
        self.name = name
        self.secPerBeat = secPerBeat
    }
}
