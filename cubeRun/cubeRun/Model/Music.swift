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
    var bpm: Double // bpm of the music
    var beats: [Beat]
    
    init(name: String, bpm: Double, beats: [Beat]) {
        self.name = name
        self.bpm = bpm
        self.beats = beats
    }
}
