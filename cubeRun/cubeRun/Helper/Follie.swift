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
        case fadeOutNode = 13
        case inGameMenu = 11
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
    
    static var selectedChapter: Int!
    
    static var sensitivity : Float = UserDefaults.standard.float(forKey: "Sensitivity")
    
    static var musicVolume : Float = UserDefaults.standard.float(forKey: "MusicVolume")
    
    static let groundRatio: Double = 1/8 // ground height ratio to the screen height
    
    static let backgroundRatio: Double = 75/292 // background1 & background2 height ratio to the screen
    
    static let screenMovementSec: Double = 25.0 // the time (seconds) it takes for a node to move a distance (screen width * 2)
    
    static let blockRatio: Double = 15/396 // music block ratio
    
    static let dashedLineRatio: Double = 1.5/396 // dashed line ratio
    
    static let hiddenSkyX: Double = 1/3 // hidden sky to hide blocks that have passed the fairy line
    
    static var xSpeed: Double {
        return (Double(Follie.screenSize.width*2) / Follie.screenMovementSec)
    } // x-coordinate movement per second based on screenMovementSec
    
    static var xPerBeat: Double {
        return Follie.xSpeed * (120/78) * Double(Follie.screenSize.width/812)
    } // fixed x distance between two beats in every chapter
    
    static let colorChangeDuration: Double = 2 // the time (seconds) it takes to gradually change from one color to another
    
    // Fairy
    static func getFairy() -> Fairy {
        return Fairy()
    }
    
    // Emitter
    static func getEmitters() -> Emitters {
        return Emitters()
    }
    
    // Block
    static func getBlock() -> Block {
        return Block()
    }
    
    // Chapter
    static func getChapter(chapterNo: Int) -> Chapter {
        return Chapter(chapterNo: chapterNo)
    }
}
