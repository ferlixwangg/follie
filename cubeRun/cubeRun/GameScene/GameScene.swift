//
//  GameScene.swift
//  cubeRun
//
//  Created by Steven Muliamin on 09/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    // Game Node & Pause Node layer
    let gameNode = SKNode()
    let pauseNode = SKNode()
    static var sharedInstance: GameScene?
    
    // Current chapter
    var chapterNo: Int = 0
    var chapterTitle: String!
    
    // Screen size
    var screenW: CGFloat!
    var screenH: CGFloat!
    
    // Fairy objects and attributes
    var fairyLine: SKSpriteNode!
    var fairyNode: SKSpriteNode!
    var fairyMaxY: CGFloat!
    var fairyMinY: CGFloat!
    var fairyUp: Bool = false
    var fairyDown: Bool = false
    
    // Emitters
    var aurora: SKEmitterNode!
    
    // Music and Block
    var music: Music!
    var totalMusicDuration: Double!
    var currMusicDuration: Double = 0
    var blockTexture: SKTexture!
    var blockHeight : Double!
    var blockWidth : Double!
    var blockTimer: Timer? = nil
    var player: AVAudioPlayer!
    let buttonClickedSfx = SKAction.playSoundFileNamed("Button Click.wav", waitForCompletion: false)
    let resumeCountdownSfx = SKAction.playSoundFileNamed("Countdown Tick.mp3", waitForCompletion: false)
    
    // Timer
    var currSec: Double!
    var diffSec: Double!
    
    // Pause Menu
    var pauseText: SKLabelNode!
    var resumeButton: SKSpriteNode!
    var backToMainMenuButton: SKSpriteNode!
    var countownNode: SKLabelNode!
    var resumeCountdown : Int = 3
    var pauseToPlayTimer: Timer? = nil
    
    // Tutorial
    var onTuto: Bool = false
    var onTutoChap1: Bool = !(UserDefaults.standard.bool(forKey: "Tutorial1Completed"))
    var onTutoChap2: Bool = !(UserDefaults.standard.bool(forKey: "Tutorial2Completed"))
    var limitMovement: Bool = false // so that player cannot move before the first tutorial start
    var firstTuto: Bool = false // indicator whether the first tutorial is done or not
    var firstTutoDistance: CGFloat = 0 // how much movement should be done before the first tutorial is finished
    var secondTuto: Bool = false // indicator whether the second tutorial is done or not
    var secondTutoFlag: Bool = false // indicator when players can start tapping on the screen during the second tutorial
    var thirdTuto: Bool = false // indicator whether the third tutorial (the first star part) is done or not
    var thirdTuto2: Bool = false // indicator whether the third tutorial (the second star) is done or not
    var thirdTutoFlag: Bool = false // // indicator when players can start tapping on the screen during the third tutorial
    var thirdTutoFlag2: Bool = false
    var thirdTutoCount: Int = 0 // To detect the number of the first star on the third tutorial
    var tutorialText: SKLabelNode! // Text node
    var helpingFingerUp: SKSpriteNode! // finger animation
    var helpingFingerDown: SKSpriteNode!
    var helpingFingerTap: SKSpriteNode!
    var helpingFingerHold: SKSpriteNode!
    var textHasBeenDisplayed: Bool = false // a flag so that the same text won't be displayed multiple times
    var textBox: SKShapeNode!
    var engLangSelection: Bool = UserDefaults.standard.bool(forKey: "EnglishLanguage")
    var allTutorialText: Dictionary <String, String> = [
        "tuto1Eng":"Use your left thumb to move Follie up and down.",
        "tuto1Indo":"Gunakan jempol kanan kamu untuk menggerakan Follie naik dan turun.",
        "tuto2Eng":"Position Follie to align with the star and tap it using your right thumb.",
        "tuto2Indo":"Posisikan Follie sejajar dengan bintang dan tekan layar menggunakan jempol kanan kamu.",
        "tuto3Eng":"Try to keep Follie on the line. Hold and release at the end of the line.",
        "tuto3Indo":"Pastikan Follie selalu berada di garis. Tahan dan lepaskan pada akhir garis.",
        "tuto3FailEng":"Oops! You've missed the star. Let's try again.",
        "tuto3FailIndo":"Ups! Kamu gagal untuk menekan bintang tepat waktu. Mari coba lagi.",
        "passed1TutoEng":"Okay, that's all for now.",
        "passed1TutoIndo":"Ok, itu saja untuk saat ini.",
        "passed2TutoEng":"You have 5 lives. Try not to miss the star.",
        "passed2TutoIndo":"Kamu memiliki 5 nyawa. Cobalah untuk menekan bintang tepat waktu.",
        "passed3TutoEng":"Every 2 successful hits will regain 1 of your life.",
        "passed3TutoIndo":"Kamu akan mendapatkan kembali 1 nyawa setiap 2 bintang yang ditekan tepat waktu.",
        "passed4TutoEng":"Let's catch the star with Follie!",
        "passed4TutoIndo":"Mari mulai menangkap bintang dengan Follie!",
        "passed5TutoEng":"Okay, you're all set!",
        "passed5TutoIndo":"Ok, kamu sudah siap!"
    ]
    var tempText: String = ""
    var repeatTutorial = UserDefaults.standard.bool(forKey: "RepeatTuto")
    var repeatTuto1: Bool = false
    var repeatTuto2: Bool = false
    
    // Gameplay logic
    var nextCountdown: Int = 0 // new block will appear when countdown reaches 0
    var blockNameFlag: Int = 0 // incremental flag to give each block a unique name identifier
    var maxInterval: Int! // max beat interval between blocks
    var maxHoldNum: Int! // max number of connecting lines between blocks (hold gesture)
    var maxHoldBeat: Int! // max number of beats in one hold gesture between 2 blocks
    var holdChance: Double! // percentage of connecting blocks appearing
    var currBlockNameFlag: Int = 0 // name flag of closest block to reach the fairy
    
    var isChangedBlock: Bool = false
    var isClickable: Bool = false
    
    var currBlock: SKSpriteNode! // name of closest block node to reach fairy
    var currLine: SKShapeNode! // name of closest connecting line node to reach fairy
    var isBlockContact: Bool = false // whether block node is currently in contact with fairy
    var isHit: Bool = false // whether the player has successfully hit the passing block
    
    var upcomingLines: [SKShapeNode] = [] // list of upcoming lines from the closest
    var contactingLines: [SKShapeNode] = []
    var isAtLine: Bool = false // whether fairy is currently at line
    
    var upcomingBlocks: [SKSpriteNode] = []
    
    let maxAurora: CGFloat = 16 // max aurora birthrate
    var currAurora: CGFloat = 0 // current aurora birthrate
    var stepAurora: CGFloat = 2 // increment step of aurora birthrate
    
    let maxLife: Double = 5 // max life
    var currLife: Double = 5 // current life
    let missVal: Double = 1 // life decrement when miss
    let correctVal: Double = 0.5 // life increment when correct
    
    var screenCover: SKShapeNode! // screen cover covering the whole scene to make fade effect when miss
    let maxCoverAlpha: CGFloat = 0.5 // screen cover max alpha
    let minCoverAlpha: CGFloat = 0 // screen cover min alpha
    var currCoverAlpha: CGFloat = 0 // screen cover current alpha
    
    var isLose: Bool = false // whether the player has lost or not
    var isWin: Bool = false // whether the player has win or not
    var isCurrentlyPaused: Bool = false // whether the scene is paused
    var gameNodeIsPaused: Bool = false // whether the game node is paused
    var auroraTimer: Timer? = nil // aurora following fairy when game ends
    var fairyCurrPosition: CGPoint! // fairy position when game ends, created this var to allow aurora to follow fairy
    
    var isDismiss: Bool = false // check if screen will be dismissed so it doesnt call presentScene multiple times
    
    var progressNode: SKSpriteNode!
    var progressDistance: CGFloat!
    
    var lifeArray: [SKSpriteNode] = []
    
    var lifeBar: SKSpriteNode!
    
    // new var ------------------------------------------------------
    var blockX: CGFloat!
    var toFairyTime: Double!
    var totalTime: Double!
    var totalDistance: Double!
    var tempBeats: [Beat]!
    var isFirstBeat: Bool = true
    var linesY: [Int:CGFloat] = [:]
    var xPerBeat: Double!
    
    var currBeat: Double = 0
    var hasStarted: Bool = true
    // new var ------------------------------------------------------
    
    deinit {
        print("game scene deinit")
        // check if scene is dismissed after presenting another scene
    }
    
    override func didMove(to view: SKView) {
        self.addChild(self.gameNode)
        self.addChild(self.pauseNode)
        GameScene.sharedInstance = self
        
        self.chapterNo = Follie.selectedChapter
        
        self.initialSetup()
        if (self.repeatTutorial == true){
            self.setupPause()
            if (self.chapterNo == 1){
                self.onTuto = true
                self.repeatTuto1 = true
                self.limitMovement = true
                self.startTutorial()
            }
            else if (self.chapterNo == 2){
                self.onTuto = true
                self.repeatTuto2 = true
                self.thirdTuto = true
                self.startTutorial3()
            }
        }
        else if (self.onTutoChap1 == true && self.chapterNo == 1){
            self.onTuto = true
            self.limitMovement = true
            self.startTutorial()
        }
        else if (self.onTutoChap2 == true && self.chapterNo == 2){
            self.onTuto = true
            self.thirdTuto = true
            self.startTutorial3()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.startGameplay()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.blockTimer?.invalidate()
        self.blockTimer = nil
    }
    
    func setupTutorialLabel() {
        self.tutorialText = SKLabelNode(fontNamed: ".SFUIText")
        self.tutorialText.alpha = 0.0
        self.tutorialText.fontSize = 15 * (Follie.screenSize.height / 396)
        self.tutorialText.fontColor = UIColor.white
        self.tutorialText.position = CGPoint(x: Follie.screenSize.width*3/4, y: Follie.screenSize.height/2)
        self.tutorialText.lineBreakMode = .byWordWrapping
        self.tutorialText.numberOfLines = 0
        self.tutorialText.preferredMaxLayoutWidth = 200 * (Follie.screenSize.height / 396)
    }
    
    func startTutorial() {
        self.setupTutorialLabel()
        if self.engLangSelection == true{
            self.tempText = "\(self.allTutorialText["tuto1Eng"]!)"
        }
        else{
            self.tempText = "\(self.allTutorialText["tuto1Indo"]!)"
        }
        self.tutorialText.text = self.tempText
        self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
        self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
        self.textBox.fillColor = .black
        self.textBox.alpha = 0.5
        self.tutorialText.position = CGPoint(x: Follie.screenSize.width / 2, y: Follie.screenSize.height * 1 / 4)
        self.tutorialText.addChild(self.textBox)
        self.gameNode.addChild(self.tutorialText)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.limitMovement = false
            self.scene?.speed = 0.5
            self.tutorialText.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
            
            var texture = SKTexture(imageNamed: "Swipe Up")
            self.helpingFingerUp = SKSpriteNode(texture: texture)
            
            texture = SKTexture(imageNamed: "Swipe Down")
            self.helpingFingerDown = SKSpriteNode(texture: texture)
            
            self.helpingFingerUp.setScale(0.7)
            if UIDevice.current.hasNotch {
                self.helpingFingerUp.position = CGPoint(x: self.helpingFingerUp.size.width/3*2, y: Follie.screenSize.height/5*2.5)
            }
            else{
                self.helpingFingerUp.position = CGPoint(x: self.helpingFingerUp.size.width/3, y: Follie.screenSize.height/5*2.5)
            }
            self.helpingFingerUp.alpha = 0
            
            self.helpingFingerDown.setScale(0.7)
            if UIDevice.current.hasNotch {
                self.helpingFingerDown.position = CGPoint(x: self.helpingFingerDown.size.width/3*2, y: Follie.screenSize.height/5*3.5)
            }
            else{
                self.helpingFingerDown.position = CGPoint(x: self.helpingFingerDown.size.width/3, y: Follie.screenSize.height/5*3.5)
            }
            self.helpingFingerDown.alpha = 0
            
            let fingerDownAction: [SKAction] = [
                SKAction.fadeAlpha(to: 1.0, duration: 0.3),
                SKAction.moveTo(y: Follie.screenSize.height/5*2.5, duration: 0.7),
                SKAction.fadeAlpha(to: 0, duration: 0.3),
                SKAction.moveTo(y: Follie.screenSize.height/5*3.5, duration: 0),
                SKAction.wait(forDuration: 1.5)
            ]
            
            self.helpingFingerDown.run(SKAction.repeatForever((SKAction.sequence(fingerDownAction))))
            self.helpingFingerDown.position.y = Follie.screenSize.height/5*3.5
            
            let fingerUpAction: [SKAction] = [
                SKAction.wait(forDuration: 1.5),
                SKAction.fadeAlpha(to: 1.0, duration: 0.3),
                SKAction.moveTo(y: Follie.screenSize.height/5*3.5, duration: 0.7),
                SKAction.fadeAlpha(to: 0, duration: 0.3),
                SKAction.moveTo(y: Follie.screenSize.height/5*2.5, duration: 0)
            ]
            
            self.helpingFingerUp.run(SKAction.repeatForever((SKAction.sequence(fingerUpAction))))
            self.helpingFingerUp.position.y = Follie.screenSize.height/5*2.5
            
            self.gameNode.addChild(self.helpingFingerDown)
            self.gameNode.addChild(self.helpingFingerUp)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.firstTuto = true
            }
        })
    }
    
    func startTutorial2() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            let newBlock = SKSpriteNode(texture: self.blockTexture)
            newBlock.size = CGSize(width: 15, height: 15)
            newBlock.zPosition = Follie.zPos.visibleBlock.rawValue
            
            newBlock.name = "\(self.blockNameFlag)"
            newBlock.physicsBody = SKPhysicsBody(rectangleOf: newBlock.size)
            newBlock.physicsBody?.isDynamic = true
            newBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
            newBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
            newBlock.physicsBody?.collisionBitMask = 0
            
            // get min distance from fairy to newBlock, get min multiplier for how many beats for block to reach fairy
            // get distance from min beats
            let minDistance = self.screenW - self.fairyNode.position.x + newBlock.size.width/2
            let xPerBeat = Follie.xSpeed * self.music.secPerBeat * Follie.blockToGroundSpeed
            let minMultiplier: Double = ceil(Double(minDistance) / xPerBeat)
            let distance = xPerBeat * minMultiplier
            
            let blockX = self.fairyNode.position.x + CGFloat(distance)
            let blockY = (Follie.getFairy().maxY + Follie.getFairy().minY) / 2
            newBlock.position = CGPoint(x: blockX, y: blockY)
            
            let totalDistance: Double = Double(blockX + newBlock.size.width/2)
            let toFairyTime: Double = minMultiplier * self.music.secPerBeat
            let totalTime: Double = toFairyTime * (totalDistance / distance)
            
            let actions: [SKAction] = [
                SKAction.moveBy(x: CGFloat(-totalDistance), y: 0, duration: totalTime),
                SKAction.removeFromParent()
            ]
            newBlock.run(SKAction.sequence(actions))
            self.gameNode.addChild(newBlock)
            self.upcomingBlocks.append(newBlock)
            self.blockNameFlag += 1
        })
    }
    
    func startTutorial3() {
        // setup tuto label
        self.setupTutorialLabel()
        // new block
        let newBlock = SKSpriteNode(texture: self.blockTexture)
        newBlock.size = CGSize(width: 15, height: 15)
        newBlock.zPosition = Follie.zPos.visibleBlock.rawValue
        
        newBlock.name = "\(self.blockNameFlag)"
        newBlock.physicsBody = SKPhysicsBody(rectangleOf: newBlock.size)
        newBlock.physicsBody?.isDynamic = true
        newBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
        newBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
        newBlock.physicsBody?.collisionBitMask = 0
        
        // get min distance from fairy to newBlock, get min multiplier for how many beats for block to reach fairy
        // get distance from min beats
        let minDistance = self.screenW - self.fairyNode.position.x + newBlock.size.width/2
        let xPerBeat = Follie.xSpeed * self.music.secPerBeat * Follie.blockToGroundSpeed
        let minMultiplier: Double = ceil(Double(minDistance) / xPerBeat)
        let distance = xPerBeat * minMultiplier
        
        let blockX = self.fairyNode.position.x + CGFloat(distance)
        let blockY = (Follie.getFairy().maxY + Follie.getFairy().minY) / 2
        newBlock.position = CGPoint(x: blockX, y: blockY)
        
        let totalDistance: Double = Double(blockX + newBlock.size.width/2)
        let toFairyTime: Double = minMultiplier * self.music.secPerBeat
        let totalTime: Double = toFairyTime * (totalDistance / distance)
        let blockSpeed: Double = totalDistance / totalTime
        
        let actions: [SKAction] = [
            SKAction.moveBy(x: CGFloat(-totalDistance), y: 0, duration: totalTime),
            SKAction.removeFromParent()
        ]
        newBlock.run(SKAction.sequence(actions))
        self.gameNode.addChild(newBlock)
        self.upcomingBlocks.append(newBlock)
        self.blockNameFlag += 1
        
        // chance of connecting beats (hold)
        var prevNodePos = newBlock.position
        var n: Double = 0 // nth beat after newBlock
        
        let connectingBlock = SKSpriteNode(texture: self.blockTexture)
        connectingBlock.size = CGSize(width: 15, height: 15)
        connectingBlock.zPosition = Follie.zPos.visibleBlock.rawValue
        
        connectingBlock.name = "\(self.blockNameFlag)"
        connectingBlock.physicsBody = SKPhysicsBody(rectangleOf: connectingBlock.size)
        connectingBlock.physicsBody?.isDynamic = true
        connectingBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
        connectingBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
        connectingBlock.physicsBody?.collisionBitMask = 0
        
        let holdBeatNum: Int = 1
        n += Double(holdBeatNum)
        
        let connectingX = blockX + CGFloat(xPerBeat * n)
        let connectingY = blockY
        let connectingDistance = totalDistance + (xPerBeat * n)
        let connectingTime = totalTime + (self.music.secPerBeat * n)
        
        connectingBlock.position = CGPoint(x: connectingX, y: connectingY)
        
        let connectingActions: [SKAction] = [
            SKAction.moveBy(x: CGFloat(-connectingDistance), y: 0, duration: connectingTime),
            SKAction.removeFromParent()
        ]
        connectingBlock.run(SKAction.sequence(connectingActions))
        self.gameNode.addChild(connectingBlock)
        self.upcomingBlocks.append(connectingBlock)
        
        // Define start & end point for line
        let startPoint = prevNodePos
        let endPoint = connectingBlock.position
        
        // Create path
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let pattern : [CGFloat] = [5.0, 5.0]
        let dashPath = path.cgPath.copy(dashingWithPhase: 1, lengths: pattern)
        
        let dashedLine = SKShapeNode(path: dashPath)
        dashedLine.zPosition = Follie.zPos.visibleBlock.rawValue
        dashedLine.lineWidth = 1.5
        dashedLine.strokeColor = SKColor.white
        
        dashedLine.name = "\(self.blockNameFlag)"
        dashedLine.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
        dashedLine.physicsBody?.isDynamic = true
        dashedLine.physicsBody?.categoryBitMask = Follie.categories.holdLineCategory.rawValue
        dashedLine.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
        dashedLine.physicsBody?.collisionBitMask = 0
        
        let lineX = prevNodePos.x + (connectingX - prevNodePos.x)/2
        let lineDistance = CGFloat(totalDistance) + (lineX - blockX) + dashedLine.frame.width/2
        let lineTime: Double = Double(lineDistance / CGFloat(blockSpeed))
        
        let lineActions: [SKAction] = [
            SKAction.moveBy(x: -lineDistance, y: 0, duration: lineTime),
            SKAction.removeFromParent()
        ]
        dashedLine.run(SKAction.sequence(lineActions))
        self.gameNode.addChild(dashedLine)
        self.upcomingLines.append(dashedLine)
        
        self.blockNameFlag += 1
        prevNodePos = connectingBlock.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameNodeIsPaused == true {
            self.gameNode.isPaused = true
        }
        
        if (self.onTuto == true) {
            
            self.gameNode.enumerateChildNodes(withName: "*") {
                node , stop in
                if (self.onTutoChap1 == true && self.chapterNo == 1 || self.repeatTutorial == true && self.repeatTuto1 == true){
                    
                    // Check if the star for first tutorial is getting closer
                    if (node is SKSpriteNode && node.name == "0") {
                        
                        if (node.position.x - self.fairyNode.position.x < 50 && node.position.x - self.fairyNode.position.x >= 15 && self.secondTuto == true) {
                            
                            self.scene?.speed = 0.3
                            
                            if (self.textHasBeenDisplayed == false) {
                                if self.engLangSelection == true{
                                    self.tempText = "\(self.allTutorialText["tuto2Eng"]!)"
                                }
                                else{
                                    self.tempText = "\(self.allTutorialText["tuto2Indo"]!)"
                                }
                                self.tutorialText.text = self.tempText
                                self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                                self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                                self.textBox.fillColor = .black
                                self.textBox.alpha = 0.5
                                self.tutorialText.addChild(self.textBox)
                                self.tutorialText.position = CGPoint(x: Follie.screenSize.width / 2, y: Follie.screenSize.height * 1 / 4)
                                self.gameNode.addChild(self.tutorialText)
                                self.textHasBeenDisplayed = true
                                
                                let texture = SKTexture(imageNamed: "Tap")
                                self.helpingFingerTap = SKSpriteNode(texture: texture)
                                self.helpingFingerTap.setScale(0.7)
                                self.helpingFingerTap.position = CGPoint(x: Follie.screenSize.width - self.helpingFingerTap.size.width/3, y: Follie.screenSize.height/2)
                                self.helpingFingerTap.alpha = 0
                                
                                let fingerTapAction: [SKAction] = [
                                    SKAction.fadeAlpha(to: 1.0, duration: 0.1),
                                    SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                                ]
                                self.helpingFingerTap.run(SKAction.repeatForever((SKAction.sequence(fingerTapAction))))
                                self.gameNode.addChild(self.helpingFingerTap)
                            }
                        } else if (node.position.x - self.fairyNode.position.x < 15 && self.secondTuto == true) {
                            self.secondTutoFlag = true
                            self.scene?.speed = 0.0
                        } else {
                            self.scene?.speed = 1.0
                        }
                    }
                }
                else if (self.onTutoChap2 == true && self.chapterNo == 2 || self.repeatTutorial == true && self.repeatTuto2 == true) {
                    // Check if the star for third tutorial is getting closer
                    if (node is SKSpriteNode && node.name == "\(self.thirdTutoCount)") {
                        
                        // Check the first star of the third tutorial
                        if (node.position.x - self.fairyNode.position.x < 50 && node.position.x - self.fairyNode.position.x >= 15  && self.thirdTuto == true) {
                            self.scene?.speed = 0.3
                            
                            if (self.textHasBeenDisplayed == false) {
                                if self.engLangSelection == true{
                                    self.tempText = "\(self.allTutorialText["tuto3Eng"]!)"
                                }
                                else{
                                    self.tempText = "\(self.allTutorialText["tuto3Indo"]!)"
                                }
                                self.tutorialText.text = self.tempText
                                self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                                self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                                self.textBox.fillColor = .black
                                self.textBox.alpha = 0.5
                                self.tutorialText.position = CGPoint(x: Follie.screenSize.width / 2, y: Follie.screenSize.height * 1 / 4)
                                self.tutorialText.alpha = 1
                                self.tutorialText.addChild(self.textBox)
                                self.gameNode.addChild(self.tutorialText)
                                self.textHasBeenDisplayed = true
                                
                                let texture = SKTexture(imageNamed: "Hold")
                                self.helpingFingerHold = SKSpriteNode(texture: texture)
                                self.helpingFingerHold.setScale(0.7)
                                self.helpingFingerHold.position = CGPoint(x: Follie.screenSize.width-self.helpingFingerHold.size.width/3, y: Follie.screenSize.height/2)
                                self.helpingFingerHold.alpha = 0
                                
                                let fingerHoldAction: [SKAction] = [
                                    SKAction.fadeAlpha(to: 1.0, duration: 0.1),
                                    SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                                ]
                                self.helpingFingerHold.run(SKAction.repeatForever((SKAction.sequence(fingerHoldAction))))
                                self.gameNode.addChild(self.helpingFingerHold)
                            }
                        }
                        else if (node.position.x - self.fairyNode.position.x < 15 && self.thirdTuto == true) {
                            self.thirdTutoFlag = true
                            self.scene?.speed = 0.0
                        }
                        else {
                            self.scene?.speed = 1.0
                        }
                    }
                }
            }
        }
    }
    
    func initialSetup() {
        // Set initial physics world (to enable collision check)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.setScreenSize()
        
        self.setChapter()
        
        self.setBlock()
        self.setFairy()
        self.setAurora()
        
        self.setScreenCover()
        
    } // setup before gameplay starts (load and put in place all nodes)
    
    func setBlock() {
        let block = Follie.getBlock()
        self.blockHeight = Double(Follie.screenSize.height) * Follie.blockRatio
        self.blockWidth = (self.blockHeight / 15) * 15
        self.blockTexture = block.blockTexture
    }
    
    func setChapter() {
        let chapter = Follie.getChapter(chapterNo: self.chapterNo)
        
        // chapter music
        self.music = chapter.getMusic()
        
        guard let url = Bundle.main.url(forResource: self.music.name, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            self.player.delegate = self
            self.player.numberOfLoops = 0
            self.totalMusicDuration = self.player.duration
        } catch let error {
            print(error.localizedDescription)
        }
        
        // chapter background
        let tempNodes = chapter.getBackgroundNodes()
        
        for node in tempNodes {
            self.gameNode.addChild(node)
        }
        
        // chapter title
        self.chapterTitle = chapter.getTitle()
        
        // chapter difficulty
        let tempDifficulty = chapter.getDifficulty()
        self.maxInterval = tempDifficulty.maxInterval
        self.maxHoldNum = tempDifficulty.maxHoldNum
        self.maxHoldBeat = tempDifficulty.maxHoldBeat
        self.holdChance = tempDifficulty.holdChance
    }
    
    func startGameplay() {
        self.currSec = Date().timeIntervalSince1970 * 1000.0
        
        self.setupLife()
        self.animateProgress()
        self.setupPause()
        
        if (self.chapterNo > 2) {
            self.progressNode.run(SKAction.moveBy(x: self.progressDistance, y: 0, duration: self.totalMusicDuration))
            self.player.play()
            self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat, target: self, selector: #selector(blockProjectiles), userInfo: nil, repeats: true)
        }
        else {
            // melody
            self.hasStarted = false
            self.setupGameplay()
            self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat/4, target: self, selector: #selector(melodyProjectiles), userInfo: nil, repeats: true)
        }
    }
    
    func setupGameplay() {
        let tempsize = CGSize(width: 15, height: 15)
        
        // get min distance from fairy to newBlock, get min multiplier for how many beats for block to reach fairy
        // get distance from min beats
        let minDistance = self.screenW - self.fairyNode.position.x + tempsize.width/2
        self.xPerBeat = Follie.xSpeed * self.music.secPerBeat * Follie.blockToGroundSpeed
        let minMultiplier: Double = ceil(Double(minDistance) / self.xPerBeat)
        let distance = self.xPerBeat * minMultiplier
        
        self.blockX = self.fairyNode.position.x + CGFloat(distance)
        
        self.totalDistance = Double(self.blockX + tempsize.width/2)
        self.toFairyTime = minMultiplier * self.music.secPerBeat
        self.totalTime = self.toFairyTime * (self.totalDistance / distance)
        
        let allowedYDistance = self.fairyMaxY - self.fairyMinY
        let yInterval: Double = Double(allowedYDistance) / 4
        
        for i in (0...4) {
            self.linesY[i+1] = self.fairyMinY + CGFloat(Double(i) * yInterval)
        }
        
        self.tempBeats = self.music.beats
    }
    
    @objc func melodyProjectiles() {
        if (self.isFirstBeat) {
            self.isFirstBeat = false
            
            self.gameNode.run(SKAction.wait(forDuration: self.toFairyTime)) {
                self.player.play()
                self.hasStarted = true
                self.progressNode.run(SKAction.moveBy(x: self.progressDistance, y: 0, duration: self.totalMusicDuration))
            }
        }
        else {
            self.currBeat += 1/4
            
            if !(self.currBeat == self.tempBeats.first?.nextBeatIn) {
                return
            }
            else {
                self.currBeat = 0
                self.tempBeats.remove(at: 0)
                
                if (self.tempBeats.isEmpty) {
                    return
                }
            }
        }
        
        // new block
        let newBlock = SKSpriteNode(texture: self.blockTexture)
        newBlock.size = CGSize(width: 15, height: 15)
        newBlock.zPosition = Follie.zPos.visibleBlock.rawValue
        
        newBlock.name = "\(self.blockNameFlag)"
        newBlock.physicsBody = SKPhysicsBody(rectangleOf: newBlock.size)
        newBlock.physicsBody?.isDynamic = true
        newBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
        newBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
        newBlock.physicsBody?.collisionBitMask = 0
        
        let blockY = self.linesY[(self.tempBeats.first?.nthLine)!]
        newBlock.position = CGPoint(x: self.blockX, y: blockY!)
        
        let actions: [SKAction] = [
            SKAction.moveBy(x: CGFloat(-self.totalDistance), y: 0, duration: self.totalTime),
            SKAction.removeFromParent()
        ]
        newBlock.run(SKAction.sequence(actions))
        self.gameNode.addChild(newBlock)
        
        self.upcomingBlocks.append(newBlock)
        self.blockNameFlag += 1
        
        if ((self.tempBeats.first?.connectToNext)!) {
            let additionalX: Double = self.tempBeats.first!.nextBeatIn * self.xPerBeat
            
            let newX = self.blockX + CGFloat(additionalX)
            let newY = self.linesY[self.tempBeats[1].nthLine]
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: blockX, y: blockY!))
            path.addLine(to: CGPoint(x: newX, y: newY!))
            
            let pattern : [CGFloat] = [5.0, 5.0]
            let dashPath = path.cgPath.copy(dashingWithPhase: 1, lengths: pattern)
            
            let dashedLine = SKShapeNode(path: dashPath)
            dashedLine.zPosition = Follie.zPos.visibleBlock.rawValue
            dashedLine.lineWidth = 1.5
            dashedLine.strokeColor = SKColor.white
            
            dashedLine.name = "\(self.blockNameFlag)"
            dashedLine.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
            dashedLine.physicsBody?.isDynamic = true
            dashedLine.physicsBody?.categoryBitMask = Follie.categories.holdLineCategory.rawValue
            dashedLine.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
            dashedLine.physicsBody?.collisionBitMask = 0
            
            //            let lineX = newX + CGFloat(additionalX/2)
            let blockSpeed: Double = self.totalDistance / self.totalTime
            let lineDistance = CGFloat(self.totalDistance) + dashedLine.frame.width
            let lineTime: Double = Double(lineDistance / CGFloat(blockSpeed))
            
            let lineActions: [SKAction] = [
                SKAction.moveBy(x: -lineDistance, y: 0, duration: lineTime),
                SKAction.removeFromParent()
            ]
            dashedLine.run(SKAction.sequence(lineActions))
            self.gameNode.addChild(dashedLine)
            self.upcomingLines.append(dashedLine)
        }
    }
    
    @objc func blockProjectiles() {
        if (self.nextCountdown > 0) {
            self.nextCountdown -= 1
            return
        }
        
        // new block
        let newBlock = SKSpriteNode(texture: self.blockTexture)
        newBlock.size = CGSize(width: self.blockWidth, height: self.blockHeight)
        newBlock.zPosition = Follie.zPos.visibleBlock.rawValue
        
        newBlock.name = "\(self.blockNameFlag)"
        newBlock.physicsBody = SKPhysicsBody(rectangleOf: newBlock.size)
        newBlock.physicsBody?.isDynamic = true
        newBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
        newBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
        newBlock.physicsBody?.collisionBitMask = 0
        
        let blockY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
        newBlock.position = CGPoint(x: self.blockX, y: blockY)

        let blockSpeed: Double = self.totalDistance / self.totalTime
        
        let actions: [SKAction] = [
            SKAction.moveBy(x: CGFloat(-self.totalDistance), y: 0, duration: self.totalTime),
            SKAction.removeFromParent()
        ]
        newBlock.run(SKAction.sequence(actions))
        self.gameNode.addChild(newBlock)
        self.upcomingBlocks.append(newBlock)
        self.blockNameFlag += 1
        
        // chance of connecting beats (hold)
        var prevNodePos = newBlock.position
        var n: Double = 0 // nth beat after newBlock
        var holdCountFlag: Int = self.maxHoldNum
        while (Double.random(in: 0 ... 1) <= self.holdChance) {
            if (holdCountFlag == 0) {
                break
            }
            holdCountFlag -= 1
            
            let connectingBlock = SKSpriteNode(texture: self.blockTexture)
            connectingBlock.size = CGSize(width: self.blockWidth, height: self.blockHeight)
            connectingBlock.zPosition = Follie.zPos.visibleBlock.rawValue
            
            connectingBlock.name = "\(self.blockNameFlag)"
            connectingBlock.physicsBody = SKPhysicsBody(rectangleOf: connectingBlock.size)
            connectingBlock.physicsBody?.isDynamic = true
            connectingBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
            connectingBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
            connectingBlock.physicsBody?.collisionBitMask = 0
            
            let holdBeatNum: Int = Int.random(in: 1 ... self.maxHoldBeat)
            n += Double(holdBeatNum)
            
            let connectingX = self.blockX + CGFloat(self.xPerBeat * n)
            let connectingY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
            let connectingDistance = self.totalDistance + (self.xPerBeat * n)
            let connectingTime = self.totalTime + (self.music.secPerBeat * n)
            
            connectingBlock.position = CGPoint(x: connectingX, y: connectingY)
            
            let connectingActions: [SKAction] = [
                SKAction.moveBy(x: CGFloat(-connectingDistance), y: 0, duration: connectingTime),
                SKAction.removeFromParent()
            ]
            connectingBlock.run(SKAction.sequence(connectingActions))
            self.gameNode.addChild(connectingBlock)
            self.upcomingBlocks.append(connectingBlock)

            // Define start & end point for line
            let startPoint = prevNodePos
            let endPoint = connectingBlock.position
            
            // Create path
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let pattern : [CGFloat] = [5.0, 5.0]
            let dashPath = path.cgPath.copy(dashingWithPhase: 1, lengths: pattern)
            
            let dashedLine = SKShapeNode(path: dashPath)
            dashedLine.zPosition = Follie.zPos.visibleBlock.rawValue
            dashedLine.lineWidth = Follie.screenSize.height * CGFloat(Follie.dashedLineRatio)
            dashedLine.strokeColor = SKColor.white
            
            dashedLine.name = "\(self.blockNameFlag)"
            dashedLine.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
            dashedLine.physicsBody?.isDynamic = true
            dashedLine.physicsBody?.categoryBitMask = Follie.categories.holdLineCategory.rawValue
            dashedLine.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
            dashedLine.physicsBody?.collisionBitMask = 0
            
            let lineX = prevNodePos.x + (connectingX - prevNodePos.x)/2
            //            let lineY = prevNodePos.y + (connectingY - prevNodePos.y)/2
            let lineDistance = CGFloat(self.totalDistance) + (lineX - self.blockX) + dashedLine.frame.width/2
            let lineTime: Double = Double(lineDistance / CGFloat(blockSpeed))
            
            let lineActions: [SKAction] = [
                SKAction.moveBy(x: -lineDistance, y: 0, duration: lineTime),
                SKAction.removeFromParent()
            ]
            dashedLine.run(SKAction.sequence(lineActions))
            self.gameNode.addChild(dashedLine)
            self.upcomingLines.append(dashedLine)
            
            self.blockNameFlag += 1
            prevNodePos = connectingBlock.position
        }
        
        self.nextCountdown = Int.random(in: 0 ... self.maxInterval) + Int(n)
    }
    
    func animateProgress() {
        let progressLineTexture = SKTexture(imageNamed: "progressLine")
        let progressLine = SKSpriteNode(texture: progressLineTexture)
        
        let newWidth = screenW * 0.7
        let newHeight: CGFloat = 3/396 * Follie.screenSize.height
        
        progressLine.size = CGSize(width: newWidth, height: newHeight)
        progressLine.position = CGPoint(x: screenW/2, y: screenH/10*9)
        progressLine.zPosition = Follie.zPos.visibleBlock.rawValue
        progressLine.alpha = 0
        progressLine.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        progressLine.name = "Progress Line inGame"
        self.gameNode.addChild(progressLine)
        
        let progressNodeTexture = SKTexture(imageNamed: "gameSnowflake")
        self.progressNode = SKSpriteNode(texture: progressNodeTexture)
        
        let newH: CGFloat = 20/396 * Follie.screenSize.height
        let newW = self.progressNode.size.width * (newH / self.progressNode.size.height)
        self.progressNode.size = CGSize(width: newW, height: newH)
        
        let newX = progressLine.position.x - progressLine.size.width/2
        progressLine.position.y -= progressNode.size.height/2
        self.progressNode.position = CGPoint(x: newX, y: progressLine.position.y + progressNode.size.height/2)
        self.progressNode.zPosition = Follie.zPos.visibleBlock.rawValue
        self.progressNode.alpha = 0
        self.progressNode.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        self.gameNode.addChild(self.progressNode)
        
        self.progressDistance = progressLine.size.width
    }
    
    func setupLife() {
        let lifeTexture = SKTexture(imageNamed: "lifePiece")
        
        for i in 1 ... Int(self.maxLife) {
            let lifeNode = SKSpriteNode(texture: lifeTexture)
            lifeNode.anchorPoint = CGPoint(x: 0.5, y: -0.1)
            
            let newH: CGFloat = 15/396 * Follie.screenSize.height
            let newW = lifeNode.size.width * (newH / lifeNode.size.height)
            lifeNode.size = CGSize(width: newW, height: newH)
            
            lifeNode.position = CGPoint(x: self.screenW/10, y: screenH/10*9)
            lifeNode.zPosition = Follie.zPos.visibleBlock.rawValue
            
            let radAngle = CGFloat(72 * -i) * .pi / 180
            lifeNode.run(SKAction.rotate(toAngle: radAngle, duration: 0))
            lifeNode.alpha = 0
            lifeNode.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            
            self.gameNode.addChild(lifeNode)
            self.lifeArray.append(lifeNode)
            
        }
        self.lifeArray.reverse()
    }
    
    func setupPause() {
        // Pause Button
        let pauseTexture = SKTexture(imageNamed: "Pause Button")
        let pauseButton = SKSpriteNode(texture: pauseTexture)
        pauseButton.name = "pause"
        let pauseH = pauseButton.size.height / 396 * Follie.screenSize.height
        let pauseW = pauseButton.size.width * (pauseH / pauseButton.size.height)
        pauseButton.size = CGSize(width: pauseW, height: pauseH)
        pauseButton.position = CGPoint(x: self.screenW/10*9, y: self.screenH/10*9)
        pauseButton.alpha = 0
        pauseButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        self.gameNode.addChild(pauseButton)
        
        let invisiblePauseBox = SKSpriteNode(color: .clear, size: CGSize(width: pauseW*3, height: pauseH*3))
        invisiblePauseBox.position = CGPoint(x: pauseButton.position.x, y: pauseButton.position.y)
        invisiblePauseBox.name = "pause"
        self.gameNode.addChild(invisiblePauseBox)
    }
    
    func setScreenSize() {
        self.screenH = Follie.screenSize.height
        self.screenW = Follie.screenSize.width
    }
    
    func setScreenCover() {
        self.screenCover = SKShapeNode(rectOf: CGSize(width: screenW, height: screenH))
        self.screenCover.position = CGPoint(x: screenW/2, y: screenH/2)
        self.screenCover.alpha = self.minCoverAlpha
        self.screenCover.zPosition = Follie.zPos.screenCover.rawValue
        self.screenCover.lineWidth = 0
        self.screenCover.fillColor = SKColor.black
        self.gameNode.addChild(self.screenCover)
    }
    
    func setAurora() {
        self.aurora = Follie.getEmitters().getAurora()
        self.aurora.position = CGPoint(x: (self.fairyNode.position.x - self.fairyNode.size.width/2), y: self.fairyNode.position.y)
        self.aurora.zPosition = self.fairyNode.zPosition
        let auroraH = 100 / 396 * Follie.screenSize.height
        let auroraW = 50 * (auroraH / 100)
        self.aurora.particleSize = CGSize(width: auroraW, height: auroraH)
        self.aurora.particleColorSequence = nil
        self.aurora.particleColorBlendFactorSequence = nil
        
        self.aurora.particleAction = SKAction.fadeAlpha(by: -1, duration: 1)
        self.aurora.particleColor = Follie.auroraColorRotation()
        
        self.hideAurora()
        self.gameNode.addChild(aurora)
    }
    
    func setFairy() {
        let fairy = Follie.getFairy()
        
        self.fairyMaxY = fairy.maxY
        self.fairyMinY = fairy.minY
        
        self.fairyLine = fairy.fairyLine
        self.fairyNode = fairy.fairyNode
        
        
        self.gameNode.addChild(self.fairyLine)
        self.gameNode.addChild(self.fairyNode)
        
        self.fairyNode.name = "fairyNode"
        self.fairyNode.physicsBody = SKPhysicsBody(rectangleOf: self.fairyNode.size)
        self.fairyNode.physicsBody?.isDynamic = true
        self.fairyNode.physicsBody?.categoryBitMask = Follie.categories.fairyCategory.rawValue
        self.fairyNode.physicsBody?.contactTestBitMask = Follie.categories.blockCategory.rawValue | Follie.categories.holdLineCategory.rawValue
        self.fairyNode.physicsBody?.collisionBitMask = 0
        
        self.fairyLine.name = "fairyNode"
        self.fairyLine.physicsBody = SKPhysicsBody(rectangleOf: self.fairyLine.size)
        self.fairyLine.physicsBody?.isDynamic = true
        self.fairyLine.physicsBody?.categoryBitMask = Follie.categories.fairyLineCategory.rawValue
        self.fairyLine.physicsBody?.contactTestBitMask = Follie.categories.blockCategory.rawValue | Follie.categories.holdLineCategory.rawValue
        self.fairyLine.physicsBody?.collisionBitMask = 0
    }
    
    func changeAuroraColor() {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        self.aurora.particleColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        var newR: CGFloat = 0
        var newG: CGFloat = 0
        var newB: CGFloat = 0
        let tempCol: UIColor = Follie.auroraColorRotation()
        tempCol.getRed(&newR, green: &newG, blue: &newB, alpha: nil)
        
        let difR = newR-r
        let difG = newG-g
        let difB = newB-b
        
        for i in (1 ... Int(Follie.colorChangeDuration * 10)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                r += difR/CGFloat(Follie.colorChangeDuration * 10)
                g += difG/CGFloat(Follie.colorChangeDuration * 10)
                b += difB/CGFloat(Follie.colorChangeDuration * 10)
                
                self.aurora.particleColor = UIColor.init(red: r, green: g, blue: b, alpha: 1)
            }
        }
    }
    
    func hideAurora() {
        self.currAurora = 0
        self.aurora.particleBirthRate = self.currAurora
    }

    func showAurora() {
        if (self.currAurora < self.maxAurora) {
            self.currAurora += self.stepAurora
        }

        self.aurora.particleBirthRate = self.currAurora
        self.changeAuroraColor()
    }
    
    func lose() {
        self.isLose = true
        
        for block in self.upcomingBlocks {
            block.removeAllActions()
            
            let actions: [SKAction] = [
                SKAction.wait(forDuration: 1),
                SKAction.group([
                    SKAction.repeatForever(
                        SKAction.rotate(byAngle: CGFloat.pi, duration: 1)),
                    SKAction.moveBy(x: 0, y: -(block.position.y + block.size.height/2), duration: 3),
                    SKAction.fadeOut(withDuration: 2)
                    ])
            ]
            block.run(SKAction.sequence(actions))
        }
        
        for line in self.upcomingLines {
            line.removeAllActions()
            
            line.run(SKAction.fadeAlpha(to: 0, duration: 1))
        }
        self.fairyNode.run(SKAction.wait(forDuration: 2)) {
            self.fairyNode.run(SKAction.moveTo(x: -self.fairyNode.size.width/2, duration: 3))
            self.fairyNode.run(SKAction.moveTo(y: -self.fairyNode.size.height/2, duration: 4))
            
            self.screenCover.run(SKAction.fadeAlpha(to: 0.65, duration: 4)) {
                self.scene?.run(SKAction.speed(to: 0, duration: 4))
                self.isCurrentlyPaused = true
                self.showLoseMenu()
            }
        }
        
        self.run(SKAction.wait(forDuration: 1.1)){
            self.player.setVolume(0, fadeDuration: 6)
        }
        
        self.blockTimer?.invalidate()
        self.blockTimer = nil
        
        self.progressNode.removeAllActions()
    }
    
    func showLoseMenu() {
        let progressLine = self.gameNode.childNode(withName: "Progress Line inGame")
        progressLine?.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        self.progressNode.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        let pauseButton = self.gameNode.childNode(withName: "pause")
        pauseButton?.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        let chapterTitle = SKLabelNode(fontNamed: "dearJoeII")
        chapterTitle.text = self.chapterTitle
        chapterTitle.fontSize = 100/396 * Follie.screenSize.height
        chapterTitle.fontColor = UIColor.white
        chapterTitle.position = CGPoint(x: self.screenW/2, y: self.screenH/4*3)
        chapterTitle.alpha = 0
        chapterTitle.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(chapterTitle)
        chapterTitle.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let chapterNumber = SKLabelNode(fontNamed: ".SFUIText")
        chapterNumber.text = "Chapter \(self.chapterNo)"
        chapterNumber.fontSize = 20/396 * Follie.screenSize.height
        chapterNumber.fontColor = UIColor.white
        chapterNumber.alpha = 0
        chapterNumber.position = CGPoint(x: chapterTitle.position.x, y: chapterTitle.position.y - chapterTitle.frame.height/2 - 10)
        chapterNumber.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(chapterNumber)
        chapterNumber.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let progressBackgroundTexture = SKTexture(imageNamed: "Progress Bar - Pause&End")
        let progressBackground = SKSpriteNode(texture: progressBackgroundTexture)
        let newWidth = self.screenW * 0.7
        let newHeight: CGFloat = 2/396 * Follie.screenSize.height
        progressBackground.size = CGSize(width: newWidth, height: newHeight)
        progressBackground.position = CGPoint(x: screenW/2, y: screenH/2)
        progressBackground.alpha = 0
        progressBackground.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(progressBackground)
        progressBackground.run(SKAction.fadeAlpha(to: 0.7, duration: 0.5))
        
        
        let snowflakeProgressTexture = SKTexture(imageNamed: "Snowflakes - Pause&End")
        let newH = FollieMainMenu.screenSize.height * 30/396
        let ratio = newH / snowflakeProgressTexture.size().height
        let newW = ratio * snowflakeProgressTexture.size().width
        let snowflakeProgress = SKSpriteNode(texture: snowflakeProgressTexture)
        snowflakeProgress.size = CGSize(width: newW, height: newH)
        
        let percentage = (self.progressNode.position.x - (screenW/2 - self.progressDistance/2)) / self.progressDistance
        
        let newX = progressBackground.position.x - progressBackground.size.width/2 + (CGFloat(percentage) * progressBackground.size.width)
        
        progressBackground.position.y -= snowflakeProgress.size.height/2
        snowflakeProgress.position = CGPoint(x: newX, y: progressBackground.position.y + snowflakeProgress.size.height/2)
        snowflakeProgress.zPosition = (Follie.zPos.inGameMenu.rawValue + 1)
        snowflakeProgress.alpha = 0
        self.gameNode.addChild(snowflakeProgress)
        snowflakeProgress.run(SKAction.fadeAlpha(to: 0.7, duration: 0.5))
        
        let retryTexture = SKTexture(imageNamed: "Retry Button")
        let retry = SKSpriteNode(texture: retryTexture)
        let retryHeight = retry.size.height/396 * Follie.screenSize.height
        let retryWidth: CGFloat = retry.size.width * (retryHeight / retry.size.height)
        retry.size = CGSize(width: retryWidth, height: retryHeight)
        let retryX = progressBackground.position.x + progressBackground.size.width/2 - retry.size.width/2
        retry.position = CGPoint(x: retryX, y: screenH/4)
        retry.alpha = 0
        retry.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(retry)
        retry.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        retry.name = "retry"
        
        let menuTexture = SKTexture(imageNamed: "Back To Main Menu")
        let menu = SKSpriteNode(texture: menuTexture)
        let menuHeight = menu.size.height/396 * Follie.screenSize.height
        let menuWidth = menu.size.width * (menuHeight / menu.size.height)
        menu.size = CGSize(width: menuWidth, height: menuHeight)
        let menuX = progressBackground.position.x - progressBackground.size.width/2 + menu.size.width/2
        menu.position = CGPoint(x: menuX, y: screenH/4)
        menu.alpha = 0
        menu.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(menu)
        menu.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        menu.name = "menu"
    }
    
    func missed() {
        if (self.isLose) {
            return
        }
        
        self.player.setVolume(0.2, fadeDuration: 0)
        
        self.run(SKAction.wait(forDuration: 1)) {
            self.player.setVolume(1, fadeDuration: 0)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        self.hideAurora()
        
        if (onTuto == false) {
            self.currLife -= self.missVal
            
            if !(self.currLife < 0) {
                if (floor(self.currLife) != self.currLife) {
                    // currLife is not an integer, thus containing .5 (eg. 3.5)
                    self.lifeArray[Int(ceil(self.currLife))].run(SKAction.fadeOut(withDuration: 0.5))
                    self.lifeArray[Int(self.currLife)].run(SKAction.fadeAlpha(to: 0.5, duration: 0.5))
                }
                else {
                    self.lifeArray[Int(self.currLife)].run(SKAction.fadeOut(withDuration: 0.5))
                }
            }
            
            if (self.currLife <= 0) {
                // lose
                self.lifeArray[0].run(SKAction.fadeOut(withDuration: 0.5))
                self.lose()
            }
        }
    }
    
    func win() {
        let distance = self.fairyNode.size.width/2 + self.screenW - self.fairyNode.position.x
        let time = Double(distance) / (Follie.xSpeed*2)
        self.fairyNode.run(SKAction.wait(forDuration: 2)) {
            self.screenCover.run(SKAction.fadeAlpha(to: 0.65, duration: time))
            
            self.fairyCurrPosition = self.fairyNode.position
            self.auroraTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.auroraFollowFairy), userInfo: nil, repeats: true)
            
            self.fairyNode.run(SKAction.moveBy(x: distance, y: 0, duration: time)) {
                self.auroraTimer?.invalidate()
                self.auroraTimer = nil

                // go back to menu
                let availableLevel = UserDefaults.standard.integer(forKey: "AvailableChapter")
                if (self.chapterNo == availableLevel && availableLevel != 2) {
                    UserDefaults.standard.set(availableLevel+1, forKey: "AvailableChapter")
                }
                
                self.removeAllActions()
                self.isCurrentlyPaused = true
                self.showWinMenu()
            }
        }
    }
    
    func showWinMenu() {
        let winText = SKLabelNode(fontNamed: "dearJoeII")
        winText.text = "Completed!"
        winText.fontSize = 100 / 396 * Follie.screenSize.height
        winText.fontColor = UIColor.white
        winText.position = CGPoint(x: self.screenW/2, y: self.screenH/2 + winText.frame.height/2)
        winText.alpha = 0
        winText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(winText)
        winText.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let tapText = SKLabelNode(fontNamed: ".SFUIText")
        tapText.text = "Tap to continue"
        tapText.fontSize = 20 / 396 * Follie.screenSize.height
        tapText.fontColor = UIColor.white
        tapText.position = CGPoint(x: self.screenW/2, y: self.screenH/2 - tapText.frame.height/2)
        tapText.alpha = 0
        tapText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.gameNode.addChild(tapText)
        
        let action: [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.5),
            SKAction.fadeAlpha(to: 0, duration: 0.5)
        ]
        
        tapText.run(SKAction.repeatForever(SKAction.sequence(action)))
        
        self.isWin = true
    }
    
    func correct() {
        self.showAurora()
        
//        self.currCoverAlpha = self.screenCover.alpha - (self.maxCoverAlpha / CGFloat(self.maxLife) * CGFloat(self.correctVal))
//        if (self.currCoverAlpha <= self.minCoverAlpha) {
//            self.currCoverAlpha = self.minCoverAlpha
//        }
//        self.screenCover.run(SKAction.fadeAlpha(to: self.currCoverAlpha, duration: 0.2))

        self.currLife += self.correctVal
        if (self.currLife > self.maxLife) {
            self.currLife = self.maxLife
            return
        }
        
        if (floor(self.currLife) != self.currLife) {
            // currLife is not an integer, thus containing .5 (eg. 3.5)
            self.lifeArray[Int(self.currLife)].run(SKAction.fadeAlpha(by: 0.5, duration: 0.5))
        }
        else {
            self.lifeArray[Int(self.currLife)-1].run(SKAction.fadeAlpha(by: 0.5, duration: 0.5))

        }
    }
    
    func starDispersedEmitter() {
        let starDispersedEmitter = Follie.getEmitters().getStarDispersed()
        starDispersedEmitter.position = self.fairyNode.position
        addChild(starDispersedEmitter)
        
        self.run(SKAction.wait(forDuration: 0.2)) {
            starDispersedEmitter.particleBirthRate = 0
            self.run(SKAction.wait(forDuration: 2.5)) {
                starDispersedEmitter.removeFromParent()
            }
        }
    }
    
    func showPauseMenu(finished: @escaping () -> Void) {
        self.pauseText = SKLabelNode(fontNamed: "dearJoeII")
        self.pauseText.text = "Paused"
        self.pauseText.fontSize = 40 / 396 * Follie.screenSize.height
        self.pauseText.fontColor = UIColor.white
        self.pauseText.position = CGPoint(x: self.screenW/2, y: self.screenH*2/3)
        self.pauseText.alpha = 0
        self.pauseText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.pauseNode.addChild(self.pauseText)
        self.pauseText.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        
        let resumeTexture = SKTexture(imageNamed: "Resume Button")
        self.resumeButton = SKSpriteNode(texture: resumeTexture)
        let resumeHeight = resumeButton.size.height / 396 * Follie.screenSize.height
        let resumeWidth = resumeButton.size.width * (resumeHeight / resumeButton.size.height)
        self.resumeButton.size = CGSize(width: resumeWidth, height: resumeHeight)
        self.resumeButton.position = CGPoint(x: self.screenW*2/3, y: self.screenH/2)
        self.resumeButton.alpha = 0
        self.resumeButton.zPosition = Follie.zPos.inGameMenu.rawValue
        self.pauseNode.addChild(self.resumeButton)
        self.resumeButton.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        self.resumeButton.name = "resume"
        
        let menuTexture = SKTexture(imageNamed: "Back To Main Menu")
        self.backToMainMenuButton = SKSpriteNode(texture: menuTexture)
        let menuHeight = backToMainMenuButton.size.height / 396 * Follie.screenSize.height
        let menuWidth = backToMainMenuButton.size.width * (menuHeight / backToMainMenuButton.size.height)
        self.backToMainMenuButton.size = CGSize(width: menuWidth, height: menuHeight)
        self.backToMainMenuButton.position = CGPoint(x: self.screenW/3, y: self.screenH/2)
        self.backToMainMenuButton.alpha = 0
        self.backToMainMenuButton.zPosition = Follie.zPos.inGameMenu.rawValue
        self.pauseNode.addChild(self.backToMainMenuButton)
        self.backToMainMenuButton.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        self.backToMainMenuButton.name = "menu"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            finished()
        }
    }
    
    @objc func auroraFollowFairy() {
        let diffY = self.fairyNode.position.y - self.fairyCurrPosition.y
        let diffX = self.fairyNode.position.x - self.fairyCurrPosition.x
        
        self.fairyCurrPosition = self.fairyNode.position
        
        self.aurora.particlePosition.y += diffY
        self.aurora.particlePosition.x += diffX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact fairy & block
            var block: SKSpriteNode!
            
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            self.currBlock = block
            self.isBlockContact = true
            
            if (self.contactingLines.first?.name == block.name) {
                self.contactingLines.remove(at: 0)
            }
            
            if (block.name == "\(self.currBlockNameFlag)") {
                self.currBlockNameFlag += 1
                self.isClickable = true
            }
            
            if (self.upcomingLines.first?.name == "\(self.currBlockNameFlag)") {
                // check whether block is connected by a line
                self.contactingLines.append(self.upcomingLines.first!)
                self.upcomingLines.remove(at: 0)
                
                if (self.isAtLine) {
                    self.isHit = true
                    self.isChangedBlock = false
                    
                    self.contactingLines.first?.zPosition = Follie.zPos.hiddenSky.rawValue
                    self.upcomingBlocks.first?.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                    
                    self.starDispersedEmitter()
                    self.correct()
                }
            }
        }
        else if ((contact.bodyA.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact fairyLine & block
            var block: SKSpriteNode!
            
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            if (self.contactingLines.first?.name == block.name) {
                self.contactingLines.remove(at: 0)
            }
            
            if (block.name == "\(self.currBlockNameFlag)") {
                self.currBlockNameFlag += 1
            }
            
            if (self.upcomingLines.first?.name == "\(self.currBlockNameFlag)") {
                // check whether block is connected by a line
                self.contactingLines.append(self.upcomingLines.first!)
                self.upcomingLines.remove(at: 0)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact end fairyLine & block
            var block: SKSpriteNode!
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            self.isClickable = false
            self.isChangedBlock = true
            
            if (self.isAtLine && self.isHit) {
                // safe
            }
            else if (!self.isHit) {
                // miss single block
                self.missed()
                self.isAtLine = false
                
                if (self.contactingLines.first?.name == "\(self.currBlockNameFlag)") {
                    print("miss single")
                    self.contactingLines.first!.strokeColor = SKColor.red
                    
                    let actions: [SKAction] = [
                        SKAction.fadeOut(withDuration: 0.3),
                        SKAction.removeFromParent()
                    ]
                    self.contactingLines.first!.run(SKAction.sequence(actions))
                    self.contactingLines.remove(at: 0)
                    
                    self.missed()
                }
                
                block.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
                block.run(SKAction.moveBy(x: 0, y: -(block.position.y + block.size.height/2), duration: 1.5))
                block.run(SKAction.fadeOut(withDuration: 1))
            }
            
            self.isHit = false
            self.upcomingBlocks.remove(at: 0)
            
            if (self.onTuto == false && !self.isLose && self.upcomingBlocks.isEmpty) {
                self.win()
                return
            }
        }
        else if ((contact.bodyA.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact end fairy & block
            self.isBlockContact = false
            self.currBlock = nil
            
            
        }
        else if ((contact.bodyA.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.holdLineCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.holdLineCategory.rawValue)) {
            // contact end fairy & line
            var line: SKShapeNode!
            if (contact.bodyA.categoryBitMask == Follie.categories.holdLineCategory.rawValue) {
                // bodyA is line
                line = (contact.bodyA.node as! SKShapeNode)
            }
            else {
                // bodyB is line
                line = (contact.bodyB.node as! SKShapeNode)
            }
            
            if (self.isAtLine) {
                if (self.contactingLines.count > 0) {
                    let lineNameInt = Int(line.name!)
                    let tempName = Int((self.upcomingBlocks.first?.name)!)! + 1
                    if ((!self.isBlockContact) || (tempName == lineNameInt)) {
                        self.missed()
                        
                        self.contactingLines.first!.strokeColor = SKColor.red
                        
                        let actions: [SKAction] = [
                            SKAction.fadeOut(withDuration: 0.3),
                            SKAction.removeFromParent()
                        ]
                        self.contactingLines.first!.run(SKAction.sequence(actions))
                        self.contactingLines.remove(at: 0)
                        self.isAtLine = false
                        self.isHit = false
                    }
                    // safe
                }
                else {
                    // success on first star but fairy moved out of line
                    print("miss long")
                    self.missed()
                    
                    self.isAtLine = false
                    self.isHit = false
                }
            }
        }
    }
    
    func successfulHit() {
        // successfully hit
        self.isHit = true
        if (self.currBlock != nil) {
            self.currBlock.zPosition = Follie.zPos.hiddenBlockArea.rawValue
        }
        self.upcomingBlocks.first?.zPosition = Follie.zPos.hiddenBlockArea.rawValue
        
        self.starDispersedEmitter()
        self.correct()
        
        if (self.contactingLines.count > 0) {
            // hit connecting block
            self.isAtLine = true
            self.contactingLines.first?.zPosition = Follie.zPos.hiddenBlockArea.rawValue
        }
    }
    
    func backToMainMenu() {
        self.isDismiss = true
        
        self.removeAllActions()
        self.scene?.speed = 1
        
        FollieMainMenu.showFollieTitle = false
        
        let fadeOutNode = SKShapeNode(rectOf: CGSize(width: screenW, height: screenH))
        fadeOutNode.position = CGPoint(x: screenW/2, y: screenH/2)
        fadeOutNode.alpha = 0
        fadeOutNode.fillColor = SKColor.black
        fadeOutNode.lineWidth = 0
        fadeOutNode.zPosition = Follie.zPos.fadeOutNode.rawValue
        self.addChild(fadeOutNode)
        
        self.blockTimer?.invalidate()
        self.blockTimer = nil
        self.player = nil
        GameScene.sharedInstance = nil
        
        fadeOutNode.run(SKAction.fadeAlpha(to: 1, duration: 1.0)) {
            self.gameNode.removeAllActions()
            self.gameNode.removeAllChildren()
            let newScene = MainMenu(size: FollieMainMenu.screenSize)
            newScene.scaleMode = self.scaleMode
            let animation = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: animation)
        }
        return
    }
    
    func startResumeTimer() {
        countownNode = SKLabelNode(fontNamed: "dearJoeII")
        countownNode.text = String(self.resumeCountdown)
        countownNode.fontSize = 60 / 396 * Follie.screenSize.height
        countownNode.fontColor = UIColor.white
        countownNode.position = CGPoint(x: self.screenW/2, y: self.screenH/2)
        countownNode.alpha = 0
        countownNode.zPosition = Follie.zPos.inGameMenu.rawValue
        self.pauseNode.addChild(countownNode)
        
        self.pauseToPlayTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startToPlayCounting), userInfo: nil, repeats: true)
    }
    
    @objc func startToPlayCounting() {
        
        self.run(self.resumeCountdownSfx)
        let action : [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.2),
            SKAction.wait(forDuration: 0.2)
        ]
        
        countownNode.run(SKAction.sequence(action))
        
        if resumeCountdown == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.gameNodeIsPaused = false
                self.gameNode.isPaused = false
                self.countownNode.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                self.screenCover.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                
                if (self.hasStarted && self.repeatTutorial == false) {
                    self.player.play()
                }
                
                self.resumeTimer()
                self.pauseToPlayTimer?.invalidate()
                self.pauseToPlayTimer = nil
                self.resumeCountdown = 3
                self.isDismiss = false
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.resumeCountdown -= 1
                self.countownNode.text = String(self.resumeCountdown)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self.scene!)
        let touchedNodes = self.scene!.nodes(at: positionInScene)
        
        if (self.isDismiss) {
            return
        }
        
        if (self.isLose) {
            for node in touchedNodes {
                if (node.name != nil && node.name == "menu") {
                    self.run(self.buttonClickedSfx)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.backToMainMenu()
                    }
                }
                else if (node.name != nil && node.name == "retry") {
                    self.run(self.buttonClickedSfx)
                    self.isDismiss = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.removeAllActions()
                        self.scene?.speed = 1
                        
                        let fadeOutNode = SKShapeNode(rectOf: CGSize(width: self.screenW, height: self.screenH))
                        fadeOutNode.position = CGPoint(x: self.screenW/2, y: self.screenH/2)
                        fadeOutNode.alpha = 0
                        fadeOutNode.fillColor = SKColor.black
                        fadeOutNode.lineWidth = 0
                        fadeOutNode.zPosition = Follie.zPos.fadeOutNode.rawValue
                        self.gameNode.addChild(fadeOutNode)
                        
                        fadeOutNode.run(SKAction.fadeAlpha(to: 1, duration: 1.0)) {
                            // Preload animation
                            var preAtlas = [SKTextureAtlas]()
                            preAtlas.append(SKTextureAtlas(named: "Baby"))
                            
                            // Move to next scene
                            SKTextureAtlas.preloadTextureAtlases(preAtlas, withCompletionHandler: { () -> Void in
                                DispatchQueue.main.sync {
                                    let newScene = GameScene(size: Follie.screenSize)
                                    newScene.scaleMode = self.scaleMode
                                    let animation = SKTransition.fade(withDuration: 2.0)
                                    self.view?.presentScene(newScene, transition: animation)
                                }
                            })
                        }
                        return
                    }
                }
            }
            return
        }
        
        if (self.isWin) {
            self.backToMainMenu()
        }
        
//        self.blockTimer?.invalidate()
//        self.blockTimer = nil
        
        for node in touchedNodes {
            if (node.name != nil && node.name == "pause") {
                if (self.isCurrentlyPaused == false) {
                    self.isCurrentlyPaused = true
                    self.screenCover.run(SKAction.fadeAlpha(to: 0.65, duration: 0.1)) {
                        self.showPauseMenu {
                            self.gameNodeIsPaused = true
                            self.gameNode.isPaused = true
                            self.pauseTimer()
                            self.player.pause()
                        }
                    }
                }
                
                return
            }
            else if (node.name != nil && node.name == "menu") {
                self.run(self.buttonClickedSfx)
                UserDefaults.standard.set(false, forKey: "RepeatTuto")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.gameNodeIsPaused = true
//                    self.gameNode.isPaused = false
                    self.backToMainMenu()
                }
            }
            else if (node.name != nil && node.name == "resume") {
                self.isDismiss = true
                self.run(self.buttonClickedSfx)
                let goneAction = SKAction.fadeAlpha(to: 0, duration: 0.1)
                self.pauseText.run(goneAction)
                self.backToMainMenuButton.run(goneAction)
                self.resumeButton.run(goneAction)
                
                // self.screnCover, self.player, self.resumeTimer pindah ke function startToPlayCounting()
                self.startResumeTimer()
                return
            }
        }
        
        guard let point = touches.first?.location(in: self) else { return }
        
        if (point.x > screenW/2) {
            // touch right part of the screen start
            if (self.isBlockContact && !self.isHit) {
                
                if (self.currBlock != nil && self.currBlock.name == "\(self.thirdTutoCount)"){
                    self.thirdTutoFlag2 = true
                }
                else{
                    self.thirdTutoFlag2 = false
                }
                
                if (self.onTuto == true) {
                    if (self.onTutoChap1 == true && self.chapterNo == 1 || self.repeatTutorial == true && repeatTuto1 == true){
                        // Tutorial 2 baru bisa done kalo udah berhenti
                        if (self.secondTuto == true && self.secondTutoFlag == true) {
                            self.scene?.speed = 1.0
                            
                            self.secondTuto = false
                            self.secondTutoFlag = false
                            
                            self.tutorialText.removeAllChildren()
                            self.tutorialText.removeFromParent()
                            self.helpingFingerTap.removeFromParent()
                            self.textHasBeenDisplayed = false
                            
                            // Start Gameplay
                            
                            let action: [SKAction] = [
                                SKAction.wait(forDuration: 2),
                                SKAction.fadeAlpha(to: 1, duration: 0.5),
                                SKAction.wait(forDuration: 2.5),
                                SKAction.fadeAlpha(to: 0, duration: 0.5)
                            ]
                            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                            if self.engLangSelection == true{
                                self.tempText = "\(self.allTutorialText["passed1TutoEng"]!)"
                            }
                            else{
                                self.tempText = "\(self.allTutorialText["passed1TutoIndo"]!)"
                            }
                            self.tutorialText.text = self.tempText
                            self.tutorialText.alpha = 0
                            self.tutorialText.run(fadeIn)
                            self.tutorialText.run(SKAction.sequence(action))
                            self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                            self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                            self.textBox.fillColor = .black
                            self.textBox.alpha = 0.5
                            self.tutorialText.position = CGPoint(x: Follie.screenSize.width*3/4, y: Follie.screenSize.height/2)
                            self.tutorialText.addChild(self.textBox)
                            self.gameNode.addChild(self.tutorialText)
                            
                            self.run(SKAction.wait(forDuration: 5.5)) {
                                self.tutorialText.removeAllChildren()
                                if self.engLangSelection == true{
                                    self.tempText = "\(self.allTutorialText["passed2TutoEng"]!)"
                                }
                                else{
                                    self.tempText = "\(self.allTutorialText["passed2TutoIndo"]!)"
                                }
                                self.tutorialText.text = self.tempText
                                self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                                self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                                self.textBox.fillColor = .black
                                self.textBox.alpha = 0.5
                                self.tutorialText.addChild(self.textBox)
                                self.tutorialText.run(SKAction.sequence(action))
                                
                                let textureHealth = SKTexture(imageNamed: "Hp")
                                self.lifeBar = SKSpriteNode(texture: textureHealth)
                                let newH: CGFloat = 30
                                let newW = self.lifeBar.size.width * (newH / self.lifeBar.size.height)
                                self.lifeBar.size = CGSize(width: newW, height: newH)
                                //                            self.lifeBar.position = CGPoint(x: self.screenW/10, y: self.screenH/10*9)
                                self.lifeBar.position = CGPoint(x: Follie.screenSize.width*3/4 - self.textBox.frame.width * 3 / 4, y: self.tutorialText.position.y + self.tutorialText.frame.height / 2)
                                self.lifeBar.zPosition = Follie.zPos.visibleBlock.rawValue
                                self.lifeBar.alpha = 0
                                self.gameNode.addChild(self.lifeBar)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                                    self.lifeBar.run(fadeIn)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    let moveUp = SKAction.move(to: CGPoint(x: self.screenW/10, y: self.screenH/10*9), duration: 2.0)
                                    self.lifeBar.run(moveUp)
                                    
                                    self.tutorialText.removeAllChildren()
                                    if self.engLangSelection == true{
                                        self.tempText = "\(self.allTutorialText["passed3TutoEng"]!)"
                                    }
                                    else{
                                        self.tempText = "\(self.allTutorialText["passed3TutoIndo"]!)"
                                    }
                                    self.tutorialText.text = self.tempText
                                    self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                                    self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                                    self.textBox.fillColor = .black
                                    self.textBox.alpha = 0.5
                                    self.tutorialText.addChild(self.textBox)
                                    self.tutorialText.run(SKAction.sequence(action))
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                                        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                                        self.lifeBar.run(fadeOut)
                                        self.tutorialText.removeAllChildren()
                                        if self.engLangSelection == true{
                                            self.tempText = "\(self.allTutorialText["passed4TutoEng"]!)"
                                        }
                                        else{
                                            self.tempText = "\(self.allTutorialText["passed4TutoIndo"]!)"
                                        }
                                        self.tutorialText.text = self.tempText
                                        self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                                        self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                                        self.textBox.fillColor = .black
                                        self.textBox.alpha = 0.5
                                        self.tutorialText.addChild(self.textBox)
                                        self.tutorialText.run(SKAction.sequence(action))
                                        
                                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
                                            self.tutorialText.removeAllChildren()
                                            self.tutorialText.removeFromParent()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
                                            
                                            if (self.repeatTutorial == true){
                                                self.repeatTutorial = false
                                                UserDefaults.standard.set(false, forKey: "RepeatTuto")
                                                self.onTuto = false
                                                self.repeatTuto1 = false
                                                self.backToMainMenu()
                                            }
                                            else if (self.repeatTutorial == false){
                                                
                                                UserDefaults.standard.set(true, forKey: "Tutorial1Completed")
                                                self.onTutoChap1 = false
                                                self.onTuto = false
                                                self.startGameplay()
                                            }
                                        }
                                    })
                                }
                            }
                            self.successfulHit()
                        }
                    }
                    else if (self.onTutoChap2 == true && self.chapterNo == 2 || self.repeatTutorial == true && self.repeatTuto2 == true) {
                        
                        // Check Tuto 3 (Kalo scenenya uda berhenti baru bisa proceed)
                        if (self.thirdTuto == true && thirdTutoFlag == true) {
                            self.thirdTuto2 = true
                            self.thirdTutoFlag = false
                            self.thirdTuto = false
                            self.successfulHit()
                        }
                    }
                }
                else{
                    if (self.isClickable) {
                        self.successfulHit()
                        self.isChangedBlock = false
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.isLose) {
            return
        }
        
        guard let point = touches.first?.location(in: self) else { return }
        
        if (point.x > screenW/2) {
            // touch right part of the screen ends
            if (self.onTuto) {
                if (self.isAtLine && self.isBlockContact && self.contactingLines.isEmpty) {
                    
                    // Passed Tutorial 3
                    if (self.thirdTuto2 == true && self.isAtLine == true && self.isBlockContact == true){
                        
                        self.thirdTuto2 = false
                        self.tutorialText.removeAllChildren()
                        self.tutorialText.removeFromParent()
                        self.helpingFingerHold.removeFromParent()
                        
                        let action: [SKAction] = [
                            SKAction.wait(forDuration: 2),
                            SKAction.fadeAlpha(to: 1, duration: 0.5),
                            SKAction.wait(forDuration: 2.5),
                            SKAction.fadeAlpha(to: 0, duration: 0.5)
                        ]
                        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                        if self.engLangSelection == true{
                            self.tempText = "\(self.allTutorialText["passed5TutoEng"]!)"
                        }
                        else{
                            self.tempText = "\(self.allTutorialText["passed5TutoIndo"]!)"
                        }
                        self.tutorialText.text = self.tempText
                        self.tutorialText.alpha = 0
                        self.tutorialText.run(fadeIn)
                        self.tutorialText.run(SKAction.sequence(action))
                        self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                        self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                        self.textBox.fillColor = .black
                        self.textBox.alpha = 0.5
                        self.tutorialText.position = CGPoint(x: Follie.screenSize.width*3/4, y: Follie.screenSize.height/2)
                        self.tutorialText.addChild(self.textBox)
                        self.gameNode.addChild(self.tutorialText)
                        
                        self.run(SKAction.wait(forDuration: 5.5)) {
                            self.tutorialText.removeAllChildren()
                            self.tutorialText.removeFromParent()
                            
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                                if (self.repeatTutorial == true){
                                    self.repeatTutorial = false
                                    UserDefaults.standard.set(false, forKey: "RepeatTuto")
                                    self.repeatTuto2 = false
                                    self.onTuto = false
                                    self.backToMainMenu()
                                }
                                else if (self.repeatTutorial == false){
                                    
                                    UserDefaults.standard.set(true, forKey: "Tutorial2Completed")
                                    self.onTuto = false
                                    self.onTutoChap2 = false
                                    self.startGameplay()
                                }
                            }
                        }
                        
                    }
                    
                    self.currBlock.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                    self.isHit = true
                    
                    self.starDispersedEmitter()
                    self.correct()
                }
                else if (self.isAtLine && self.contactingLines.first?.name == "\(self.currBlockNameFlag)") {
                    self.missed()
                    self.contactingLines.first!.strokeColor = SKColor.red
                    
                    let actions: [SKAction] = [
                        SKAction.fadeOut(withDuration: 0.3),
                        SKAction.removeFromParent()
                    ]
                    self.contactingLines.first!.run(SKAction.sequence(actions))
                    self.contactingLines.remove(at: 0)
                }
                
                // Repeat Tutorial 3 if players failed
                if (self.thirdTutoFlag2 == true && self.thirdTuto2 == true && self.isAtLine == false || self.thirdTutoFlag2 == true && self.thirdTuto2 == true && self.isBlockContact == false || (self.thirdTutoFlag2 == true && self.thirdTuto2 == true && self.isBlockContact == true && self.isAtLine == true)){
                    self.thirdTuto = true
                    self.thirdTuto2 = false
                    self.thirdTutoFlag = false
                    self.thirdTutoFlag2 = false
                    self.thirdTutoCount += 2
                    
                    self.helpingFingerHold.removeFromParent()
                    self.tutorialText.removeAllChildren()
                    self.tutorialText.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
                    if self.engLangSelection == true{
                        self.tempText = "\(self.allTutorialText["tuto3FailEng"]!)"
                    }
                    else{
                        self.tempText = "\(self.allTutorialText["tuto3FailIndo"]!)"
                    }
                    self.tutorialText.text = self.tempText
                    self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                    self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                    self.textBox.fillColor = .black
                    self.textBox.alpha = 0.5
                    self.tutorialText.addChild(self.textBox)
                    self.tutorialText.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                        self.tutorialText.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1, execute: {
                            self.textHasBeenDisplayed = false
                            self.tutorialText.removeAllChildren()
                            if self.engLangSelection == true{
                                self.tempText = "\(self.allTutorialText["tuto3Eng"]!)"
                            }
                            else{
                                self.tempText = "\(self.allTutorialText["tuto3Indo"]!)"
                            }
                            self.tutorialText.text = self.tempText
                            self.textBox = SKShapeNode(rectOf: CGSize(width: self.tutorialText.frame.width + 20, height: self.tutorialText.frame.height + 20))
                            self.textBox.position = CGPoint(x: 0, y: (self.tutorialText.frame.height / 2))
                            self.textBox.fillColor = .black
                            self.textBox.alpha = 0.5
                            self.tutorialText.addChild(self.textBox)
                            self.tutorialText.removeFromParent()
                            self.tutorialText.alpha = 1.0
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.tutorialText.removeAllChildren()
                                self.startTutorial3()
                            }
                        })
                    }
                }
                
                self.isAtLine = false
            }
            else {
                // not onTuto
                if (self.isAtLine && self.isBlockContact && self.isChangedBlock && (Int((self.upcomingBlocks.first?.name)!) == (self.currBlockNameFlag-1))) {
                    self.isHit = true
                    self.isChangedBlock = false
                    
                    self.upcomingBlocks.first?.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                    
                    self.starDispersedEmitter()
                    self.correct()
                    
                    if (self.contactingLines.count > 0) {
                        self.contactingLines.first!.strokeColor = SKColor.red
                        
                        let actions: [SKAction] = [
                            SKAction.fadeOut(withDuration: 0.3),
                            SKAction.removeFromParent()
                        ]
                        self.contactingLines.first!.run(SKAction.sequence(actions))
                        self.contactingLines.remove(at: 0)
                        
                        self.missed()
                    }
                }
                else if (self.isAtLine){
                    if (self.contactingLines.count > 0) {
                        self.contactingLines.first!.strokeColor = SKColor.red
                        
                        let actions: [SKAction] = [
                            SKAction.fadeOut(withDuration: 0.3),
                            SKAction.removeFromParent()
                        ]
                        self.contactingLines.first!.run(SKAction.sequence(actions))
                        self.contactingLines.remove(at: 0)
                        
                        self.missed()
                    }
                }
                
                self.isAtLine = false
            }
            
        }
        else {
            // touch left part of screen ends
            if (self.fairyUp) {
                self.fairyNode.run(SKAction.rotate(byAngle: -CGFloat.pi/13, duration: 0.2))
            }
            else if (self.fairyDown) {
                self.fairyNode.run(SKAction.rotate(byAngle: CGFloat.pi/13, duration: 0.2))
            }
            self.fairyDown = false
            self.fairyUp = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.isLose) {
            return
        }
        
        if (onTuto == true && self.limitMovement == true) {
            return
        }
        
        if (self.gameNode.isPaused) {
            return
        }
        
        for touch in touches{
            let point = touch.location(in: self)
            
            // if left screen
            if (point.x < screenW/2) {
                
                // Passed Tutorial 1
                if (self.firstTuto == true) {
                    self.helpingFingerDown.removeFromParent()
                    self.helpingFingerUp.removeFromParent()
                }
                
                if (self.firstTuto == true && self.firstTutoDistance>200.0) {
                    self.scene?.speed = 1.0
                    self.tutorialText.removeFromParent()
                    self.tutorialText.removeAllChildren()
                    self.firstTuto = false
                    self.secondTuto = true
                    self.startTutorial2()
                }
                
                let prevPoint = touch.previousLocation(in: self)
                
                let yMovement = point.y - prevPoint.y
                var newPositionY = self.fairyNode.position.y + yMovement
                
                self.firstTutoDistance += abs(yMovement)
                
                if (newPositionY > self.fairyMaxY) {
                    newPositionY = self.fairyMaxY
                }
                else if (newPositionY < self.fairyMinY) {
                    newPositionY = self.fairyMinY
                }
                
                if (yMovement > 0) {
                    if (!self.fairyUp) {
                        self.fairyUp = true
                        
                        if (self.fairyDown) {
                            self.fairyNode.run(SKAction.rotate(byAngle: CGFloat.pi/13*2, duration: 0.3))
                        }
                        else {
                            self.fairyNode.run(SKAction.rotate(byAngle: CGFloat.pi/13, duration: 0.2))
                        }
                    }
                    self.fairyDown = false
                }
                else {
                    if (!self.fairyDown) {
                        self.fairyDown = true
                        
                        if (self.fairyUp) {
                            self.fairyNode.run(SKAction.rotate(byAngle: -CGFloat.pi/13*2, duration: 0.3))
                        }
                        else {
                            self.fairyNode.run(SKAction.rotate(byAngle: -CGFloat.pi/13, duration: 0.2))
                        }
                    }
                    self.fairyUp = false
                }
                
                self.aurora.particlePosition.y = self.aurora.particlePosition.y + (newPositionY - self.fairyNode.position.y)
                self.fairyNode.position.y = newPositionY
            }
        }
    }
    
    func pauseTimer() {
        
        if self.repeatTutorial {
            return
        }
        
        self.blockTimer?.invalidate()
        self.blockTimer = nil
        
        if (self.chapterNo > 2) {
            self.diffSec = ((Date().timeIntervalSince1970 * 1000.0) - self.currSec) / 1000
            self.diffSec = self.diffSec.truncatingRemainder(dividingBy: self.music.secPerBeat)
            self.diffSec = self.music.secPerBeat - self.diffSec
        }
        else {
            self.diffSec = ((Date().timeIntervalSince1970 * 1000.0) - self.currSec) / 1000
            self.diffSec = self.diffSec.truncatingRemainder(dividingBy: self.music.secPerBeat/4)
            self.diffSec = self.music.secPerBeat/4 - self.diffSec
        }
    }
    
    func resumeTimer() {
        
        if self.repeatTutorial {
            self.isCurrentlyPaused = false
            return
        }
        
        if (self.chapterNo > 2) {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.diffSec) {
                self.currSec = Date().timeIntervalSince1970 * 1000.0
                self.blockProjectiles()
                
                self.isCurrentlyPaused = false
                
                self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat, target: self, selector: #selector(self.blockProjectiles), userInfo: nil, repeats: true)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.diffSec) {
                self.currSec = Date().timeIntervalSince1970 * 1000.0
                self.melodyProjectiles()
                
                self.isCurrentlyPaused = false
                
                self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat/4, target: self, selector: #selector(self.melodyProjectiles), userInfo: nil, repeats: true)
            }
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
