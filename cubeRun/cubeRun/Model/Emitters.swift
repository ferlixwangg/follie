//
//  Emitters.swift
//  cubeRun
//
//  Created by Steven Muliamin on 24/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains all emitters used
class Emitters {
    init() {}
    
    func getAurora() -> SKEmitterNode {
        return SKEmitterNode(fileNamed: "Aurora.sks")!
    } // Returns aurora emitter node
    
    func getSnow() -> SKEmitterNode {
        return SKEmitterNode(fileNamed: "Snow")!
    } // Returns snow emitter node
    
    func getStarDispersed() -> SKEmitterNode {
        return SKEmitterNode(fileNamed: "Star Disperse")!
    } // Returns star dispersed emitter node
}
