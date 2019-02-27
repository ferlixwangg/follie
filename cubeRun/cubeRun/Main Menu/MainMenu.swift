//
//  MainMenu.swift
//  cubeRun
//
//  Created by Ferlix Yanto Wang on 01/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit
import UIKit

class MainMenu: SKScene {
    
    // Layer nodes
    let mainMenuNode = SKNode()
    let settingsNode = SKNode()
    
    var engLangSelection: Bool = UserDefaults.standard.bool(forKey: "EnglishLanguage")
    var tuto1Done: Bool = UserDefaults.standard.bool(forKey: "Tutorial1Completed")
    var tuto2Done: Bool = UserDefaults.standard.bool(forKey: "Tutorial2Completed")
    
    /// UserDefault value of the unlocked chapters
    let availableChapter: Int = FollieMainMenu.availableChapter
    
    /// Background music of the main menu
    let backgroundMusic = SKAudioNode(fileNamed: "DYATHON - Monologue.mp3")
    
    /// Soundeffects for the clicked chapter
    var clickedChapterSfx = SKAction.playSoundFileNamed("Rising Chapter.wav", waitForCompletion: false)
    var playedChapterSfx = SKAction.playSoundFileNamed("Play Chapter.wav", waitForCompletion: false)
    
    // Screen size
    var screenW: CGFloat!
    var screenH: CGFloat!
    
    // Nodes in the main menu
    var sky: SKSpriteNode!
    var gameTitle: SKSpriteNode!
    var ground: SKSpriteNode!
    var chapterTitle: SKLabelNode!
    var mountain: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    
    // Variables for flag to detect selected chapter
    var activeChapter = SKSpriteNode()
    var activeChapterName = String()
    
    // Camera Down Animation elements
    var cameraDownOnGoing: Bool = false
    var skyFinalY: CGFloat!
    var gameTitalFinalY: CGFloat!
    var groundFinalY: CGFloat!
    var isDismiss: Bool!
    
    // DispatchWorkTask for ChapterTitle Animation
    var task: DispatchWorkItem? = nil
    
    // To disable the chances of tapping chapter multiple times
    var chapterChosen: Bool!
    
    // Settings nodes
    var isInSettings: Bool!
    var effectNode: SKEffectNode!
    var settingsBackground: SKShapeNode!
    var settingsTitle: SKLabelNode!
    var backButton: SKSpriteNode!
    var innerSettingsBackground: SKShapeNode!
    var musicVolumeText: SKLabelNode!
    var sensitivityText: SKLabelNode!
    var volumeSlider: UISlider!
    var sensitivitySlider: UISlider!
    var languageText : SKLabelNode!
    var englishButton : SKSpriteNode!
    var indonesiaButton: SKSpriteNode!
    var mostInnerSettingsBackground: SKShapeNode!
    var replayTutorialText: SKLabelNode!
    var basicButton: SKSpriteNode!
    var holdButton: SKSpriteNode!
    let buttonClickedSfx = SKAction.playSoundFileNamed("Button Click.wav", waitForCompletion: false)
    
    deinit {
        print("main menu deinit")
    }
    
    override func didMove(to view: SKView) {
//        let showFollieTitle = FollieMainMenu.showFollieTitle
        let showFollieTitle = false
        
        self.isDismiss = true
        self.isInSettings = false
        
        if (showFollieTitle == true) {
            self.run(SKAction.wait(forDuration: 1)) {
                self.splashScreen()
            }
            
            self.run(SKAction.wait(forDuration: 10)){
                self.initialVignette()
                self.setNodes()
                self.snowEmitter()
                self.startBackgroundMusic()
                
                self.cameraDownOnGoing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if (self.cameraDownOnGoing == true) {
                        self.isDismiss = false
                        self.cameraDownAnimation()
                    }
                }
                self.setActiveChapter(duration: 5.5)
            }
        } else {
            self.isDismiss = false
            self.setNodes()
            self.snowEmitter()
            self.startBackgroundMusic()
            self.settingsButton.alpha = 1.0
            
            self.cameraDownOnGoing = false
            let goUpDuration = 0.0
            self.beginMoveByAnimation(goUpDuration: goUpDuration)
            FollieMainMenu.showFollieTitle = true
            self.setActiveChapter(duration: 0)
        }
        
        self.chapterChosen = false
    }
    
    func startBackgroundMusic() {
        self.backgroundMusic.autoplayLooped = true
        self.addChild(self.backgroundMusic)
    }
    
    func stopBackgroundMusic() {
        self.backgroundMusic.removeFromParent()
    }
    
    func splashScreen() {
        let teamFollieText = SKLabelNode(fontNamed: "dearJoeII")
        teamFollieText.text = "Team Follie"
        teamFollieText.fontSize = CGFloat(100 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        teamFollieText.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        teamFollieText.alpha = 0
        
        let splashAction : [SKAction] = [
            SKAction.fadeIn(withDuration: 2),
            SKAction.fadeOut(withDuration: 2),
            SKAction.removeFromParent()
        ]
        
        teamFollieText.run(SKAction.sequence(splashAction))
        
        self.addChild(teamFollieText)
        
        let headphoneTexture = SKTexture(imageNamed: "Headphone")
        let headphoneIcon = SKSpriteNode(texture: headphoneTexture)
        headphoneIcon.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/10*7)
        headphoneIcon.alpha = 0
        let headphoneH = 60/396 * FollieMainMenu.screenSize.height
        let headphoneW = headphoneIcon.size.width * (headphoneH / headphoneIcon.size.height)
        headphoneIcon.size = CGSize(width: headphoneW, height: headphoneH)
        
        let useHeadphoneText = SKLabelNode(fontNamed: ".SFUIText")
        useHeadphoneText.text = "Use headphones for best experience"
        useHeadphoneText.fontSize = CGFloat(20 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        useHeadphoneText.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        useHeadphoneText.alpha = 0
        
        let musicByText = SKLabelNode(fontNamed: ".SFUIText")
        musicByText.text = "music by"
        musicByText.fontSize = CGFloat(20 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        musicByText.position = CGPoint(x: FollieMainMenu.screenSize.width/2 - (100/396 * FollieMainMenu.screenSize.height), y: FollieMainMenu.screenSize.height/10*4)
        musicByText.alpha = 0
        
        let dyathonText = SKLabelNode(fontNamed: "dearJoeII")
        dyathonText.text = "D y a t h o n"
        dyathonText.fontSize = CGFloat(40 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        dyathonText.position = CGPoint(x: FollieMainMenu.screenSize.width/2 + (40/396 * FollieMainMenu.screenSize.height) , y: FollieMainMenu.screenSize.height/10*4)
        dyathonText.alpha = 0
        
        headphoneIcon.run(SKAction.sequence(splashAction))
        useHeadphoneText.run(SKAction.sequence(splashAction))
        musicByText.run(SKAction.sequence(splashAction))
        dyathonText.run(SKAction.sequence(splashAction))
        
        self.run(SKAction.wait(forDuration: 5.0)) {
            self.addChild(headphoneIcon)
            self.addChild(useHeadphoneText)
            self.addChild(musicByText)
            self.addChild(dyathonText)
        }
    }
    
    func initialVignette() {
        let vignette = FollieMainMenu.getMainMenuBackground().getVignette()
        self.addChild(vignette)
    }
    
    func moveChapterTitleAndNumber(durationStartDispatch: Double) {
        
        self.task = DispatchWorkItem {
            self.chapterTitle.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            self.chapterTitle.run(SKAction.moveTo(y: self.chapterTitle.position.y + 10, duration: 0.5))
            
            let chapterNumber = self.chapterTitle.children.first as! SKLabelNode
            chapterNumber.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            chapterNumber.run(SKAction.moveTo(y: chapterNumber.position.y + 10, duration: 0.5))
            
            self.settingsButton.run(SKAction.fadeIn(withDuration: 0.5))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + durationStartDispatch, execute: self.task!)
    }
    
    func setActiveChapter(duration: Double) {
        let index = self.availableChapter
        self.activeChapter = self.ground.childNode(withName: "Chapter\(index)") as! SKSpriteNode
        self.activeChapterName = "Chapter\(availableChapter)"
        
        let dashLine: SKShapeNode = FollieMainMenu.getMainMenuBackground().getDashedLines()
        self.activeChapter.addChild(dashLine)
        
        self.chapterTitle.text = FollieMainMenu.getChapter(chapterNo: index).getTitle()
        let chapterNumber = self.chapterTitle.children.first as! SKLabelNode
        chapterNumber.text = "Chapter \(index)"
        chapterNumber.position = CGPoint(x: 0, y: self.chapterTitle.frame.height/2 + (10/396 * FollieMainMenu.screenSize.height))
        
        moveChapterTitleAndNumber(durationStartDispatch: duration)
        
        // Snowflakes go up
        let chapterSnowflake = self.activeChapter.children[0] as! SKSpriteNode
        self.activeChapter.run(SKAction.moveBy(x: 0, y: CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height, duration: 0))
        chapterSnowflake.run(SKAction.repeatForever(SKAction.rotate(byAngle: -0.5, duration: 1)), withKey: "repeatForeverActionKey")
        
        // Apply glowing effect on the snowflake
        let glowTexture = SKTexture(imageNamed: "Fairy Glow")
        let glow = SKSpriteNode(texture: glowTexture)
        let glowSize = chapterSnowflake.size.width + 35
        glow.size = CGSize(width: glowSize, height: glowSize)
        glow.name = "Fairy Glow"
        
        let glowAction: [SKAction] = [
            SKAction.fadeAlpha(to: 0.3, duration: 1),
            SKAction.fadeAlpha(to: 1, duration: 1),
            SKAction.wait(forDuration: 0.5)
        ]
        
        glow.run(SKAction.repeatForever(SKAction.sequence(glowAction)))
        self.activeChapter.addChild(glow)
    }
    
    func setNodes() {
        self.effectNode = SKEffectNode()
        self.effectNode.blendMode = .alpha
        self.effectNode.shouldEnableEffects = true
        self.effectNode.shouldRasterize = true
        self.effectNode.zPosition = FollieMainMenu.zPos.settingsBackground.rawValue
        self.addChild(self.effectNode)
        
        let tempBackground = FollieMainMenu.getMainMenuBackground()
        
        self.sky = tempBackground.getSkyNode()
        self.addChild(self.sky)
        
        self.gameTitle = tempBackground.getGameTitleNode()
        self.addChild(self.gameTitle)
        
        self.ground = tempBackground.getGroundNode()
        self.addChild(self.ground)
        
        self.chapterTitle = tempBackground.getChapterTitle()
        self.addChild(self.chapterTitle)
        
        self.settingsButton = tempBackground.getSettingsButton()
        self.addChild(self.settingsButton)
        
        let groundChildren = tempBackground.getGroundChildNodes()
        for child in groundChildren {
            self.ground.addChild(child)
            
            if (child.name == "Mountain") {
                self.mountain = child
            }
        }
        
        // Assign nodes final position after animation
        let goingUpRange: CGFloat = self.ground.size.height + self.gameTitle.size.height
        self.skyFinalY = self.sky.position.y + goingUpRange
        self.groundFinalY = self.ground.position.y + goingUpRange
        self.gameTitalFinalY = self.gameTitle.position.y + goingUpRange
        
        self.initiateSettingsMenu()
    } // Initialize all nodes in the main menu
    
    func snowEmitter() {
        let snowEmitter = FollieMainMenu.getEmitters().getSnow()
        snowEmitter.zPosition = FollieMainMenu.zPos.mainMenuSnow.rawValue
        snowEmitter.position = CGPoint(x: 0, y: self.sky.size.height/2)
        snowEmitter.advanceSimulationTime(20)
        self.sky.addChild(snowEmitter)
    } // Snow Emitter Declaration
    
    func cameraDownAnimation() {
        let goUpDuration = 3.0
        self.beginMoveByAnimation(goUpDuration: goUpDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.cameraDownOnGoing = false
        }
    } // To manage initial animation
    
    func beginMoveByAnimation(goUpDuration: Double) {
        
        let actionGameTitle: [SKAction] = [
            SKAction.moveTo(y: self.gameTitalFinalY, duration: goUpDuration),
            SKAction.removeFromParent()
        ]
        
        self.gameTitle.run(SKAction.sequence(actionGameTitle))
        self.gameTitle.run(SKAction.fadeOut(withDuration: goUpDuration))
        self.sky.run(SKAction.moveTo(y: self.skyFinalY, duration: goUpDuration))
        self.ground.run(SKAction.moveTo(y: self.groundFinalY, duration: goUpDuration))
    }
    
    func changeActiveChapterTitleTransition(node: SKSpriteNode, index: Int) {
        // remove the rotating snowflake animation and go down
        node.children[0].removeAction(forKey: "repeatForeverActionKey")
        let pi = Double(round(1000*CGFloat.pi/3)/1000)
        let currentRotation = Double(round(1000*node.children[0].zRotation)/1000)
        let division = Int(currentRotation / pi) - 1
        
        node.run(SKAction.moveBy(x: 0, y: -CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height, duration: 0.5))
        node.children[0].run(SKAction.rotate(toAngle: CGFloat.pi/3 * CGFloat(division), duration: 0.5))
        
        // remove the glow
        let glow = node.childNode(withName: "Fairy Glow") as! SKSpriteNode
        glow.removeFromParent()
        
        // Chapter title and number go down
        let chapterNumber = self.chapterTitle.children.first as! SKLabelNode
        
        self.chapterTitle.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        self.chapterTitle.run(SKAction.moveBy(x: 0, y: -10, duration: 0.5))
        chapterNumber.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        chapterNumber.run(SKAction.moveBy(x: 0, y: -10, duration: 0.5))
        
        // Assign new chapter title and number
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.chapterTitle.text = FollieMainMenu.getChapter(chapterNo: index).getTitle()
            chapterNumber.text = "Chapter \(index)"
            
            // Animation of going up chapter title and number
            self.chapterTitle.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            self.chapterTitle.run(SKAction.moveBy(x: 0, y: 10, duration: 0.5))
            chapterNumber.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            chapterNumber.run(SKAction.moveBy(x: 0, y: 10, duration: 0.5))
            
            // remove the dash line
            node.childNode(withName: "Dashline")?.removeFromParent()
        }
    }
    
    func initiateSettingsMenu() {
        settingsBackground = SKShapeNode(rectOf: CGSize(width: FollieMainMenu.screenSize.width, height: FollieMainMenu.screenSize.height))
        settingsBackground.name = "Settings Background"
        settingsBackground.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        settingsBackground.alpha = 0
        settingsBackground.strokeColor = .clear
        settingsBackground.fillColor = .white
        settingsBackground.zPosition = FollieMainMenu.zPos.settingsBackground.rawValue
        self.effectNode.addChild(settingsBackground)
        
        settingsTitle = SKLabelNode(fontNamed: "dearJoeII")
        settingsTitle.name = "Settings Title"
        if (engLangSelection) {
            settingsTitle.text = "Settings"
        } else {
            settingsTitle.text = "Pengaturan"
        }
        settingsTitle.fontSize = 55/396 * FollieMainMenu.screenSize.height
        settingsTitle.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/10*8)
        settingsTitle.alpha = 0
        settingsTitle.fontColor = .white
        settingsTitle.zPosition = FollieMainMenu.zPos.settingsTitleLevel.rawValue
        self.addChild(settingsTitle)
        
        var backTexture = SKTexture()
        if (engLangSelection) {
            backTexture = SKTexture(imageNamed: "Back Button")
        } else {
            backTexture = SKTexture(imageNamed: "Kembali Button")
        }
        backButton = SKSpriteNode(texture: backTexture)
        backButton.name = "Back Button Settings"
        let backButtonHeight = 15/396 * FollieMainMenu.screenSize.height
        let backButtonWidth = backButton.size.width * (backButtonHeight / backButton.size.height)
        backButton.size = CGSize(width: backButtonWidth, height: backButtonHeight)
        backButton.position = CGPoint(x: FollieMainMenu.screenSize.width/11, y: FollieMainMenu.screenSize.height/10 * 8.5)
        backButton.alpha = 0
        backButton.zPosition = FollieMainMenu.zPos.settingsTitleLevel.rawValue
        self.addChild(backButton)
        
        innerSettingsBackground = SKShapeNode(rectOf: CGSize(width: FollieMainMenu.screenSize.width/5*4, height: FollieMainMenu.screenSize.height/5*3))
        innerSettingsBackground.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: self.settingsTitle.position.y - self.settingsTitle.frame.height/2 - self.innerSettingsBackground.frame.height/2)
        innerSettingsBackground.name = "Settings Inner Background"
        innerSettingsBackground.alpha = 0
        innerSettingsBackground.strokeColor = .clear
        innerSettingsBackground.fillColor = .white
        innerSettingsBackground.zPosition = FollieMainMenu.zPos.settingsInnerBackground.rawValue
        self.addChild(innerSettingsBackground)
        
        sensitivityText = SKLabelNode(fontNamed: ".SFUIText")
        if (engLangSelection) {
            sensitivityText.text = "Sensitivity"
        } else {
            sensitivityText.text = "Sensitivitas"
        }
        sensitivityText.name = "Settings Sensitivity"
        sensitivityText.horizontalAlignmentMode = .left
        sensitivityText.fontSize = 18/396 * FollieMainMenu.screenSize.height
        sensitivityText.position = CGPoint(x: FollieMainMenu.screenSize.width/5 - sensitivityText.frame.width/2, y: FollieMainMenu.screenSize.height/10*5.2)
        sensitivityText.alpha = 0
        sensitivityText.fontColor = .white
        sensitivityText.zPosition = FollieMainMenu.zPos.settingsElementsInInnerBackground.rawValue
        self.addChild(sensitivityText)
        
        let sliderWidth = 100/396 * FollieMainMenu.screenSize.height
        let sliderHeight = 10/396 * FollieMainMenu.screenSize.height
        sensitivitySlider = UISlider(frame: CGRect(x: FollieMainMenu.screenSize.width/5*3.55, y: FollieMainMenu.screenSize.height-sensitivityText.position.y-sensitivityText.frame.height*1.25, width: sliderWidth, height: sliderHeight))
        sensitivitySlider.maximumValue = 1.0
        sensitivitySlider.minimumValue = 0.0
        sensitivitySlider.isContinuous = true
        sensitivitySlider.value = 1.0
        sensitivitySlider.alpha = 0.0
        sensitivitySlider.minimumTrackTintColor = UIColor.white
        sensitivitySlider.maximumTrackTintColor = UIColor.gray
        sensitivitySlider.setThumbImage(UIImage.init(named: "Knob"), for: .normal)
        sensitivitySlider.tag = 2
        sensitivitySlider.addTarget(self, action: #selector(self.updateSlider(_:)), for: .valueChanged)
        view?.addSubview(sensitivitySlider)
        
        musicVolumeText = SKLabelNode(fontNamed: ".SFUIText")
        musicVolumeText.name = "Settings Music Volume"
        if (engLangSelection) {
            musicVolumeText.text = "Music Volume"
        } else {
            musicVolumeText.text = "Volume musik"
        }
        musicVolumeText.horizontalAlignmentMode = .left
        musicVolumeText.fontSize = 18/396 * FollieMainMenu.screenSize.height
        musicVolumeText.position = CGPoint(x: FollieMainMenu.screenSize.width/5 - sensitivityText.frame.width/2, y: FollieMainMenu.screenSize.height/10*6.2)
        musicVolumeText.alpha = 0
        musicVolumeText.fontColor = .white
        musicVolumeText.zPosition = FollieMainMenu.zPos.settingsElementsInInnerBackground.rawValue
        self.addChild(musicVolumeText)
        
        volumeSlider = UISlider(frame: CGRect(x: FollieMainMenu.screenSize.width/5*3.55, y: FollieMainMenu.screenSize.height-musicVolumeText.position.y-musicVolumeText.frame.height*1.25, width: sliderWidth, height: sliderHeight))
        volumeSlider.maximumValue = 1.0
        volumeSlider.minimumValue = 0.0
        volumeSlider.isContinuous = true
        volumeSlider.value = 1.0
        volumeSlider.alpha = 0.0
        volumeSlider.minimumTrackTintColor = UIColor.white
        volumeSlider.maximumTrackTintColor = UIColor.gray
        volumeSlider.setThumbImage(UIImage.init(named: "Knob"), for: .normal)
        volumeSlider.tag = 1
        volumeSlider.addTarget(self, action: #selector(self.updateSlider(_:)), for: .valueChanged)
        view?.addSubview(volumeSlider)
        
        languageText = SKLabelNode(fontNamed: ".SFUIText")
        languageText.name = "Settings Language"
        if (engLangSelection) {
            languageText.text = "Language"
        } else {
            languageText.text = "Bahasa"
        }
        languageText.horizontalAlignmentMode = .left
        languageText.fontSize = 18/396 * FollieMainMenu.screenSize.height
        languageText.position = CGPoint(x: FollieMainMenu.screenSize.width/5 - sensitivityText.frame.width/2, y: FollieMainMenu.screenSize.height/10*4.2)
        languageText.alpha = 0
        languageText.fontColor = .white
        languageText.zPosition = FollieMainMenu.zPos.settingsElementsInInnerBackground.rawValue
        self.addChild(languageText)
        
        var indonesiaButtonTexture = SKTexture()
        if (engLangSelection) {
            indonesiaButtonTexture = SKTexture(imageNamed: "Indonesia Nonactive")
        } else {
            indonesiaButtonTexture = SKTexture(imageNamed: "Indonesia Active")
        }
        indonesiaButton = SKSpriteNode(texture: indonesiaButtonTexture)
        indonesiaButton.name = "Settings Indonesia Button"
        indonesiaButton.size = CGSize(width: indonesiaButton.size.width * (languageText.frame.height*1.25/indonesiaButton.size.height), height: languageText.frame.height*1.25)
        indonesiaButton.position = CGPoint(x: FollieMainMenu.screenSize.width/10*8.5 - indonesiaButton.size.width/2, y: languageText.position.y + languageText.frame.height/2)
        indonesiaButton.alpha = 0.0
        indonesiaButton.zPosition = FollieMainMenu.zPos.settingsElementsInInnerBackground.rawValue
        self.addChild(indonesiaButton)
        
        var englishButtonTexture = SKTexture()
        if (engLangSelection) {
            englishButtonTexture = SKTexture(imageNamed: "English Active")
        } else {
            englishButtonTexture = SKTexture(imageNamed: "English Nonactive")
        }
        englishButton = SKSpriteNode(texture: englishButtonTexture)
        englishButton.name = "Settings English Button"
        englishButton.size = CGSize(width: englishButton.size.width * (languageText.frame.height*1.25/englishButton.size.height), height: languageText.frame.height*1.25)
        englishButton.position = CGPoint(x: indonesiaButton.position.x - indonesiaButton.size.width/2 - 20/396 * FollieMainMenu.screenSize.height - englishButton.size.width/2, y: languageText.position.y + languageText.frame.height/2)
        englishButton.alpha = 0.0
        englishButton.zPosition = FollieMainMenu.zPos.settingsElementsInInnerBackground.rawValue
        self.addChild(englishButton)
        
        mostInnerSettingsBackground = SKShapeNode(rectOf: CGSize(width: FollieMainMenu.screenSize.width/5*3.6, height: FollieMainMenu.screenSize.height/5))
        mostInnerSettingsBackground.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: self.languageText.position.y - self.languageText.frame.height - self.mostInnerSettingsBackground.frame.height/2)
        mostInnerSettingsBackground.name = "Settings Most Inner Background"
        mostInnerSettingsBackground.alpha = 0
        mostInnerSettingsBackground.strokeColor = .clear
        mostInnerSettingsBackground.fillColor = .white
        mostInnerSettingsBackground.zPosition = FollieMainMenu.zPos.settingsMostInner.rawValue
        self.addChild(mostInnerSettingsBackground)
        
        replayTutorialText = SKLabelNode(fontNamed: ".SFUIText")
        replayTutorialText.name = "Settings Replay Tutorial Text"
        if (engLangSelection) {
            replayTutorialText.text = "Replay Tutorials"
        } else {
            replayTutorialText.text = "Ulangi tutorial"
        }
        replayTutorialText.fontSize = 18/396 * FollieMainMenu.screenSize.height
        replayTutorialText.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/10*2.95)
        replayTutorialText.alpha = 0
        replayTutorialText.fontColor = .white
        replayTutorialText.zPosition = FollieMainMenu.zPos.replaySection.rawValue
        self.addChild(replayTutorialText)
        
        var basicButtonTexture = SKTexture()
        if (engLangSelection) {
            if (tuto1Done) {
                basicButtonTexture = SKTexture(imageNamed: "Basic Active")
            } else {
                basicButtonTexture = SKTexture(imageNamed: "Basic Nonactive")
            }
        } else {
            if (tuto1Done) {
                basicButtonTexture = SKTexture(imageNamed: "Dasar Active")
            } else {
                basicButtonTexture = SKTexture(imageNamed: "Dasar Nonactive")
            }
        }
        basicButton = SKSpriteNode(texture: basicButtonTexture)
        basicButton.name = "Settings Basic Button"
        basicButton.size = CGSize(width: basicButton.size.width * (languageText.frame.height*1.25/basicButton.size.height), height: languageText.frame.height*1.25)
        basicButton.position = CGPoint(x: FollieMainMenu.screenSize.width/10*4.5, y: FollieMainMenu.screenSize.height/10*2.3)
        basicButton.alpha = 0.0
        basicButton.zPosition = FollieMainMenu.zPos.replaySection.rawValue
        self.addChild(basicButton)
        
        var holdButtonTexture = SKTexture()
        if (engLangSelection) {
            if (tuto2Done) {
                holdButtonTexture = SKTexture(imageNamed: "Hold Active")
            } else {
                holdButtonTexture = SKTexture(imageNamed: "Hold Nonactive")
            }
        } else {
            if (tuto2Done) {
                holdButtonTexture = SKTexture(imageNamed: "Tahan Active")
            } else {
                holdButtonTexture = SKTexture(imageNamed: "Tahan Nonactive")
            }
        }
        holdButton = SKSpriteNode(texture: holdButtonTexture)
        holdButton.name = "Settings Hold Button"
        holdButton.size = CGSize(width: holdButton.size.width * (languageText.frame.height*1.25/holdButton.size.height), height: languageText.frame.height*1.25)
        holdButton.position = CGPoint(x: FollieMainMenu.screenSize.width/10*5.5, y: FollieMainMenu.screenSize.height/10*2.3)
        holdButton.alpha = 0.0
        holdButton.zPosition = FollieMainMenu.zPos.replaySection.rawValue
        self.addChild(holdButton)
    }
    
    @objc func updateSlider(_ sender:UISlider!) {
        if (sender.tag == 1) {
            print("BBB")
        } else {
            print("CCC")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.chapterChosen || self.isDismiss) {
            return
        }
        
        if (self.cameraDownOnGoing == true) {
            self.gameTitle.removeAllActions()
            self.ground.removeAllActions()
            self.sky.removeAllActions()
            self.task?.cancel()
            self.moveChapterTitleAndNumber(durationStartDispatch: 0.5)
            self.beginMoveByAnimation(goUpDuration: 1)
            self.cameraDownOnGoing = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.chapterChosen || self.isDismiss) {
            return
        }
        
        // Obtain the node that is touched
        let touch: UITouch = touches.first! as UITouch
        let positionInGroundScene = touch.location(in: self.ground)
        let positionInScene = touch.location(in: self.scene!)
        let touchedGroundNodes = self.ground.nodes(at: positionInGroundScene)
        let touchedNodes = self.nodes(at: positionInScene)
        
        if (isInSettings == true) {
            
            for node in touchedNodes {
                if (node.name != nil && node.name!.contains("Back Button Settings")) {
                    self.run(self.buttonClickedSfx)
                    self.isInSettings = false
                    self.effectNode.filter = nil
                    self.settingsBackground.alpha = 0
                    self.settingsTitle.alpha = 0
                    self.backButton.alpha = 0
                    self.innerSettingsBackground.alpha = 0.0
                    self.musicVolumeText.alpha = 0.0
                    self.sensitivityText.alpha = 0.0
                    self.volumeSlider.alpha = 0.0
                    self.sensitivitySlider.alpha = 0.0
                    self.languageText.alpha = 0.0
                    self.indonesiaButton.alpha = 0.0
                    self.englishButton.alpha = 0.0
                    self.mostInnerSettingsBackground.alpha = 0.0
                    self.replayTutorialText.alpha = 0.0
                    self.basicButton.alpha = 0.0
                    self.holdButton.alpha = 0.0
                } else if (node.name != nil && node.name!.contains("Settings English Button")) {
                    self.run(self.buttonClickedSfx)
                } else if (node.name != nil && node.name!.contains("Settings Indonesia Button")) {
                    self.run(self.buttonClickedSfx)
                } else if (node.name != nil && node.name!.contains("Settings Basic Button")) {
                    if (tuto1Done) {
                        self.run(self.buttonClickedSfx)
                        // here
                        self.chapterChosen = true
                        Follie.selectedChapter = 1
                        
                        self.run(self.playedChapterSfx)
                        self.stopBackgroundMusic()
                        
                        self.run(SKAction.fadeOut(withDuration: 2.0)) {
                            // Preload animation
                            var preAtlas = [SKTextureAtlas]()
                            preAtlas.append(SKTextureAtlas(named: "Baby"))
//                            tuto1Done
                            // Move to next scene
                            SKTextureAtlas.preloadTextureAtlases(preAtlas, withCompletionHandler: { () -> Void in
                                DispatchQueue.main.sync {
                                    self.removeAllActions()
                                    self.removeAllChildren()
                                    self.task = nil
                                    let transition = SKTransition.fade(withDuration: 1)
                                    if let scene = SKScene(fileNamed: "GameScene") {
                                        scene.scaleMode = .aspectFill
                                        scene.size = Follie.screenSize
                                        self.view?.presentScene(scene, transition: transition)
                                    }
                                }
                            })
                        }
                    }
                } else if (node.name != nil && node.name!.contains("Settings Hold Button")) {
                    if (tuto2Done) {
                        self.run(self.buttonClickedSfx)
                        print("tuto2Done")
                    }
                }
            }
            
            return
        }
        
        for node in touchedNodes {
            if (node.name != nil && node.name!.contains("Settings")) {
                self.isInSettings = true
                self.run(self.buttonClickedSfx)
                
                let filter = CIFilter(name: "CIGaussianBlur")
                filter?.setValue(20.0, forKey: kCIInputRadiusKey)
                let settingsTexture = self.view?.texture(from: self.scene!, crop: self.settingsBackground.frame)
                self.settingsBackground.fillTexture = settingsTexture
                self.settingsBackground.alpha = 0.98
                self.effectNode.filter = filter
                
                self.settingsTitle.alpha = 1.0
                self.backButton.alpha = 1.0
                self.innerSettingsBackground.alpha = 0.15
                self.musicVolumeText.alpha = 1.0
                self.sensitivityText.alpha = 1.0
                self.volumeSlider.alpha = 1.0
                self.sensitivitySlider.alpha = 1.0
                self.languageText.alpha = 1.0
                self.indonesiaButton.alpha = 1.0
                self.englishButton.alpha = 1.0
                self.mostInnerSettingsBackground.alpha = 0.15
                self.replayTutorialText.alpha = 1.0
                self.basicButton.alpha = 1.0
                self.holdButton.alpha = 1.0
                
                return
            }
        }
        
        for node in touchedGroundNodes {
            // Check if the selected node is the chapter node
            if (node.name != nil && node.name!.contains("Chapter")) {
                
                // Check the chapter number using substring
                let start = node.name!.index(node.name!.startIndex, offsetBy: 7)
                let end = node.name!.endIndex
                let range = start..<end
                let index = Int(node.name![range])
                
                // Check whether the selected chapter is already unlocked
                if (index! <= self.availableChapter) {
                    
                    self.chapterChosen = true
                    
                    // Check whether the selected chapter is active or not
                    if (node.name != self.activeChapterName) {
                        
                        // Change the chapter title
                        changeActiveChapterTitleTransition(node: self.activeChapter, index: index!)
                        
                        self.activeChapter = node as! SKSpriteNode
                        self.activeChapterName = node.name!
                        
                        // add dash line
                        let dashLine: SKShapeNode = FollieMainMenu.getMainMenuBackground().getDashedLines()
                        self.activeChapter.addChild(dashLine)
                        
                        // Snowflakes go up
                        let chapterSnowflake = node.children[0] as! SKSpriteNode
                        node.run(SKAction.wait(forDuration: 0.2))
                        node.run(SKAction.moveBy(x: 0, y: CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height, duration: 0.5)) {
                            self.chapterChosen = false
                        }
                        chapterSnowflake.run(SKAction.repeatForever(SKAction.rotate(byAngle: -0.5, duration: 1)), withKey: "repeatForeverActionKey")
                        
                        // Play Sound Effect
                        self.run(self.clickedChapterSfx)
                        
                        // Apply glowing effect on the snowflake
                        let glowTexture = SKTexture(imageNamed: "Fairy Glow")
                        let glow = SKSpriteNode(texture: glowTexture)
                        let glowSize = chapterSnowflake.size.width + 35
                        glow.size = CGSize(width: glowSize, height: glowSize)
                        glow.name = "Fairy Glow"
                        
                        let glowAction: [SKAction] = [
                            SKAction.fadeAlpha(to: 0.3, duration: 1),
                            SKAction.fadeAlpha(to: 1, duration: 1),
                            SKAction.wait(forDuration: 0.5)
                        ]
                        
                        glow.run(SKAction.repeatForever(SKAction.sequence(glowAction)))
                        node.addChild(glow)
                    } else {
                        self.chapterChosen = true
                        Follie.selectedChapter = index
                        
                        self.run(self.playedChapterSfx)
                        self.stopBackgroundMusic()
                        
                        self.run(SKAction.fadeOut(withDuration: 2.0)) {
                            // Preload animation
                            var preAtlas = [SKTextureAtlas]()
                            preAtlas.append(SKTextureAtlas(named: "Baby"))
                            
                            // Move to next scene
                            SKTextureAtlas.preloadTextureAtlases(preAtlas, withCompletionHandler: { () -> Void in
                                DispatchQueue.main.sync {
                                    self.removeAllActions()
                                    self.removeAllChildren()
                                    self.task = nil
                                    let transition = SKTransition.fade(withDuration: 1)
                                    if let scene = SKScene(fileNamed: "GameScene") {
                                        scene.scaleMode = .aspectFill
                                        scene.size = Follie.screenSize
                                        self.view?.presentScene(scene, transition: transition)
                                    }
                                }
                            })
                        }
                    }
                } else {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    let unavailableNode = SKLabelNode(text: "This chapter is not unlocked yet")
                    unavailableNode.fontColor = UIColor.white
                    unavailableNode.fontName = ".SFUIText"
                    unavailableNode.fontSize = CGFloat(14 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
                    unavailableNode.preferredMaxLayoutWidth = 50
                    unavailableNode.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: self.ground.size.height * 2.5)
                    unavailableNode.alpha = 0
                    
                    let action: [SKAction] = [
                        SKAction.fadeAlpha(to: 1, duration: 0.5),
                        SKAction.wait(forDuration: 0.5),
                        SKAction.fadeAlpha(to: 0, duration: 0.5)
                    ]
                    
                    unavailableNode.run(SKAction.sequence(action)) {
                        unavailableNode.removeFromParent()
                    }
                    self.addChild(unavailableNode)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.chapterChosen || self.isDismiss) {
            return
        }
        
        for touch in touches{
            let point = touch.location(in: self)
            
            let prevPoint = touch.previousLocation(in: self)
            let xMovement = point.x - prevPoint.x
            let newPositionX = self.ground.position.x + xMovement
            
            if (newPositionX < -(self.mountain.position.x + self.mountain.size.width/2 - FollieMainMenu.screenSize.width)) {
                self.ground.position.x = -(self.mountain.position.x + self.mountain.size.width/2 - FollieMainMenu.screenSize.width)
            } else if (newPositionX > self.ground.size.width/2) {
                self.ground.position.x = self.ground.size.width/2
            } else {
                self.ground.position.x = newPositionX
            }
        }
    }
}
