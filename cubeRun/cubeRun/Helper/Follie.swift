//
//  Follie.swift
//  cubeRun
//
//  Created by Steven Muliamin on 24/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains static values used in game elements
// Also acts as an access point for GameScene to access all objects/models used in the game
class Follie {
    private init() {}
    
    enum zPos: CGFloat {
        case loseMenu = 11
        case screenCover = 10
        case fairy = 5
        case fairyGlow = -1
        case fairyLine = -4
        case ground = -5
        case background1 = -10
        case background2 = -15
        case visibleBlock = -23
        case hiddenSky = -25
        case hiddenBlockArea = -28
        case sky = -30
    } // z-position for nodes
    
    enum categories: UInt32 {
        case fairyCategory = 0
        case blockCategory = 1
        case fairyLineCategory = 2
        case holdLineCategory = 3
    }
    
    static var screenSize: CGSize {
        let screenSize = UIScreen.main.bounds
        var topSafeArea: CGFloat = 0
        var bottomSafeArea: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            topSafeArea = (window.safeAreaInsets.top)
            bottomSafeArea = (window.safeAreaInsets.bottom)
        }
        let height = screenSize.height + topSafeArea + bottomSafeArea
        
        return CGSize(width: screenSize.width, height: height)
    } // get screen size for current device
    
    static let groundRatio: Double = 1/6 // ground height ratio to the screen height
    
    static let backgroundRatio: Double = 1/3 // background1 & background2 height ratio to the screen
    
    static let screenMovementSec: Double = 25.0 // the time (seconds) it takes for a node to move a distance (screen width * 2)
    
    static let hiddenSkyX: Double = 1/3 // hidden sky to hide blocks that have passed the fairy line
    
    static var xSpeed: Double {
        return (Double(Follie.screenSize.width*2) / Follie.screenMovementSec)
    } // x-coordinate movement per second based on screenMovementSec
    
    static let blockToGroundSpeed: Double = 2 // block speed multiplier relative to the ground's
    
    static let auroraColors: [UIColor] = [
        UIColor.init(red: 0.3, green: 0, blue: 1, alpha: 1),
        UIColor.init(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor.init(red: 0.2, green: 1, blue: 0.2, alpha: 1)
    ] // possible aurora colors
    
    static var colorIndex: Int = -1 // index of current aurora color
    
    static var isRising: Bool = true // whether the color rotation is going up the index or down
    
    static let colorChangeDuration: Double = 2 // the time (seconds) it takes to gradually change from one color to another
    
    static func auroraColorRotation() -> UIColor {
        if (self.colorIndex < 0) {
            self.colorIndex = Int.random(in: 0 ..< self.auroraColors.count)
        }
        else {
            if (self.isRising) {
                if (self.colorIndex == self.auroraColors.count - 1) {
                    self.isRising = false
                    self.colorIndex -= 1
                }
                else {
                    self.colorIndex += 1
                }
            }
            else {
                if (self.colorIndex == 0) {
                    self.isRising = true
                    self.colorIndex += 1
                }
                else {
                    self.colorIndex -= 1
                }
            }
        }
        
        return self.auroraColors[self.colorIndex]
    } // returns current aurora color in rotation
    
    // Fairy
    static func getFairy() -> Fairy {
        return Fairy()
    }
    
    // Emitter
    static func getEmitters() -> Emitters {
        return Emitters()
    }
    
    // Chapter
    static func getChapter() -> Chapter {
        return Chapter()
    }
}
