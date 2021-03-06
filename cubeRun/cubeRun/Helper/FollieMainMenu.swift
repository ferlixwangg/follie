//
//  FollieMainMenu.swift
//  cubeRun
//
//  Created by Ferlix Yanto Wang on 03/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains static values used in the main menu page
class FollieMainMenu {
    private init() {}
    
    enum zPos: CGFloat {
        case mainMenuSky = -8
        case mainMenuGround = 5
        case mainMenuSnow = 2
        case mainMenuChapterNode = -3
        case mainMenuSettingsButton = 3
        case settingsBackground = 10
        case settingsTitleLevel = 11
        case settingsInnerBackground = 12
        case settingsElementsInInnerBackground = 13
        case settingsMostInner = 14
        case replaySection = 15
        case screenCover = 20
    } // z-position for nodes
    
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
    
//    static var availableChapter: Int = UserDefaults.standard.integer(forKey: "AvailableChapter")
    
    static var availableChapter: Int = 12
    
    static let groundRatio: Double = 1/6 // ground height ratio to the screen height
    
    static let gameTitleRatio: Double = 234/396 // ratio for game title
    
    static let chapterNodeRatio: Double = 66/396 // ratio for chapter nodes' size in main menu
    
    static let chapterRiseRatio: Double = 63/396 // ratio for chapter go up animation when clicked
    
    static let fontSizeRatio : Double = 1/396 // ratio for font size
    
    static let dashedLineRatio : Double = 3/396 // dashed line under selected chapter ratio
    
    static let mountainRatio : Double = 168/396 // ratio for the mountain size
    
    static var showFollieTitle: Bool = true // whether to show the title during the loading process or not
    
    // Emitter
    static func getEmitters() -> Emitters {
        return Emitters()
    }
    
    static func getChapter(chapterNo: Int) -> Chapter {
        return Chapter(chapterNo: chapterNo)
    }
    
    // Main Menu Background
    static func getMainMenuBackground() -> MainMenuBackground {
        return MainMenuBackground()
    }
}
