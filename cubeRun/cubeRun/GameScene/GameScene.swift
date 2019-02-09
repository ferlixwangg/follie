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
    
    // Current chapter
    var chapterNo: Int = 0
    var chapterTitle: String!
    
    // Screen size
    var screenW: CGFloat!
    var screenH: CGFloat!
    
    // Fairy objects and attributes
    var fairyLine: SKSpriteNode!
    var fairyNode: SKSpriteNode!
    var fairyGlow: SKSpriteNode!
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
    var blockTimer: Timer? = nil
    var player: AVAudioPlayer!
    let buttonClickedSfx = SKAction.playSoundFileNamed("Button Click.wav", waitForCompletion: false)
    
    // Timer
    var onTrackTimer: Timer? = nil
    var currSec: Double!
    var diffSec: Double!
    
    // Pause Menu
    var pauseText: SKLabelNode!
    var resumeButton: SKSpriteNode!
    var backToMainMenuButton: SKSpriteNode!
    
    // Tutorial
    var onTuto: Bool = !(UserDefaults.standard.bool(forKey: "TutorialCompleted"))
    var limitMovement: Bool = false // so that player cannot move before the first tutorial start
    var firstTuto: Bool = false // indicator whether the first tutorial is done or not
    var firstTutoDistance: CGFloat = 0 // how much movement should be done before the first tutorial is finished
    var secondTuto: Bool = false // indicator whether the second tutorial is done or not
    var secondTutoFlag: Bool = false // indicator when players can start tapping on the screen during the second tutorial
    var thirdTuto: Bool = false // indicator whether the third tutorial (the first star part) is done or not
    var thirdTuto2: Bool = false // indicator whether the third tutorial (the second star) is done or not
    var thirdTutoFlag: Bool = false // // indicator when players can start tapping on the screen during the third tutorial
    var thirdTutoFlag2: Bool = false
    var thirdTutoCount: Int = 1 // To detect the number of the first star on the third tutorial
    var tutorialText: SKLabelNode! // Text node
    var helpingFingerUp: SKSpriteNode! // finger animation
    var helpingFingerDown: SKSpriteNode!
    var helpingFingerTap: SKSpriteNode!
    var helpingFingerHold: SKSpriteNode!
    var textHasBeenDisplayed: Bool = false // a flag so that the same text won't be displayed multiple times
    
    // Gameplay logic
    var nextCountdown: Int = 0 // new block will appear when countdown reaches 0
    var blockNameFlag: Int = 0 // incremental flag to give each block a unique name identifier
    let maxInterval: Int = 1 // max beat interval between blocks
    let maxHoldNum: Int = 1 // max number of connected blocks (hold gesture)
    let maxHoldBeat: Int = 2 // max number of beats in one hold gesture between 2 blocks
    let holdChance: Double = 4/10 // percentage of connecting blocks appearing
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
    var auroraTimer: Timer? = nil // aurora following fairy when game ends
    var fairyCurrPosition: CGPoint! // fairy position when game ends, created this var to allow aurora to follow fairy
    
    var isDismiss: Bool = false // check if screen will be dismissed so it doesnt call presentScene multiple times
    
    var progressNode: SKSpriteNode!
    var progressDistance: CGFloat!
    
    var lifeArray: [SKSpriteNode] = []
    
    deinit {
        print("game scene deinit")
        // check if scene is dismissed after presenting another scene
    }
    
    override func didMove(to view: SKView) {
        self.chapterNo = Follie.selectedChapter
        
        self.initialSetup()
        
        if (onTuto == true) {
            self.limitMovement = true
            self.startTutorial()
        } else {
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
        self.tutorialText.fontSize = 20
        self.tutorialText.fontColor = UIColor.white
        self.tutorialText.position = CGPoint(x: Follie.screenSize.width*3/4, y: Follie.screenSize.height/2)
        self.tutorialText.lineBreakMode = .byWordWrapping
        self.tutorialText.numberOfLines = 0
        self.tutorialText.preferredMaxLayoutWidth = 200
    }
    
    func startTutorial() {
        self.setupTutorialLabel()
        self.tutorialText.text = "Use your left thumb to move the penguin up and down"
        self.addChild(self.tutorialText)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.limitMovement = false
            self.scene?.speed = 0.5
            self.tutorialText.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
            
            var texture = SKTexture(imageNamed: "Swipe Up")
            self.helpingFingerUp = SKSpriteNode(texture: texture)
            
            texture = SKTexture(imageNamed: "Swipe Down")
            self.helpingFingerDown = SKSpriteNode(texture: texture)
            
            self.helpingFingerUp.setScale(0.7)
            self.helpingFingerUp.position = CGPoint(x: self.helpingFingerUp.size.width/3*2, y: Follie.screenSize.height/5*2.5)
            self.helpingFingerUp.alpha = 0
            
            self.helpingFingerDown.setScale(0.7)
            self.helpingFingerDown.position = CGPoint(x: self.helpingFingerDown.size.width/3*2, y: Follie.screenSize.height/5*3.5)
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
            
            self.addChild(self.helpingFingerDown)
            self.addChild(self.helpingFingerUp)
            
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
            let blockY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
            newBlock.position = CGPoint(x: blockX, y: blockY)
            
            let totalDistance: Double = Double(blockX + newBlock.size.width/2)
            let toFairyTime: Double = minMultiplier * self.music.secPerBeat
            let totalTime: Double = toFairyTime * (totalDistance / distance)
            
            let actions: [SKAction] = [
                SKAction.moveBy(x: CGFloat(-totalDistance), y: 0, duration: totalTime),
                SKAction.removeFromParent()
            ]
            newBlock.run(SKAction.sequence(actions))
            self.addChild(newBlock)
            self.upcomingBlocks.append(newBlock)
            self.blockNameFlag += 1
        })
    }
    
    func startTutorial3() {
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
        let blockY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
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
        self.addChild(newBlock)
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
        
        let holdBeatNum: Int = Int.random(in: 1 ... self.maxHoldBeat)
        n += Double(holdBeatNum)
        
        let connectingX = blockX + CGFloat(xPerBeat * n)
        let connectingY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
        let connectingDistance = totalDistance + (xPerBeat * n)
        let connectingTime = totalTime + (self.music.secPerBeat * n)
        
        connectingBlock.position = CGPoint(x: connectingX, y: connectingY)
        
        let connectingActions: [SKAction] = [
            SKAction.moveBy(x: CGFloat(-connectingDistance), y: 0, duration: connectingTime),
            SKAction.removeFromParent()
        ]
        connectingBlock.run(SKAction.sequence(connectingActions))
        self.addChild(connectingBlock)
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
        self.addChild(dashedLine)
        self.upcomingLines.append(dashedLine)
        
        self.blockNameFlag += 1
        prevNodePos = connectingBlock.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.onTuto == true {
            self.enumerateChildNodes(withName: "*") {
                node , stop in
                
                // Check if the star for first tutorial is getting closer
                if (node is SKSpriteNode && node.name == "0") {
                    if (node.position.x - self.fairyNode.position.x < 50 && node.position.x - self.fairyNode.position.x >= 15 && self.secondTuto == true) {
                        self.scene?.speed = 0.3
                        
                        if (self.textHasBeenDisplayed == false) {
                            self.tutorialText.text = "Position the penguin to align with the beat (star) and tap it using your right thumb"
                            self.addChild(self.tutorialText)
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
                            self.addChild(self.helpingFingerTap)
                        }
                    } else if (node.position.x - self.fairyNode.position.x < 15 && self.secondTuto == true) {
                        self.secondTutoFlag = true
                        self.scene?.speed = 0.0
                    } else {
                        self.scene?.speed = 1.0
                    }
                } else if (node is SKSpriteNode && node.name == "\(self.thirdTutoCount)") {
                    
                    // Check the first star of the third tutorial
                    if (node.position.x - self.fairyNode.position.x < 50 && node.position.x - self.fairyNode.position.x >= 15  && self.thirdTuto == true) {
                        self.scene?.speed = 0.3
                        
                        if (self.textHasBeenDisplayed == false) {
                            self.addChild(self.tutorialText)
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
                            self.addChild(self.helpingFingerHold)
                        }
                    } else if (node.position.x - self.fairyNode.position.x < 15 && self.thirdTuto == true) {
                        self.thirdTutoFlag = true
                        self.scene?.speed = 0.0
                    } else {
                        self.scene?.speed = 1.0
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
            self.addChild(node)
        }
        
        // chapter title
        self.chapterTitle = chapter.getTitle()
    }
    
    func startGameplay() {
        self.player.play()
        self.currSec = Date().timeIntervalSince1970 * 1000.0
        
        self.setupLife()
        self.animateProgress()
        self.setupPause()
        
        self.progressNode.run(SKAction.moveBy(x: self.progressDistance, y: 0, duration: self.totalMusicDuration))
        
        self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat, target: self, selector: #selector(blockProjectiles), userInfo: nil, repeats: true)
    }
    
    @objc func blockProjectiles() {
        if (self.nextCountdown > 0) {
            self.nextCountdown -= 1
            return
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
        
        // get min distance from fairy to newBlock, get min multiplier for how many beats for block to reach fairy
        // get distance from min beats
        let minDistance = self.screenW - self.fairyNode.position.x + newBlock.size.width/2
        let xPerBeat = Follie.xSpeed * self.music.secPerBeat * Follie.blockToGroundSpeed
        let minMultiplier: Double = ceil(Double(minDistance) / xPerBeat)
        let distance = xPerBeat * minMultiplier
        
        let blockX = self.fairyNode.position.x + CGFloat(distance)
        let blockY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
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
        self.addChild(newBlock)
        self.upcomingBlocks.append(newBlock)
        self.blockNameFlag += 1
        
        // chance of connecting beats (hold)
        var prevNodePos = newBlock.position
        var n: Double = 0 // nth beat after newBlock
        var holdCountFlag = self.maxHoldNum
        while (Double.random(in: 0 ... 1) <= self.holdChance) {
            if (holdCountFlag == 0) {
                break
            }
            holdCountFlag -= 1
            
            let connectingBlock = SKSpriteNode(texture: self.blockTexture)
            connectingBlock.size = CGSize(width: 15, height: 15)
            connectingBlock.zPosition = Follie.zPos.visibleBlock.rawValue
            
            connectingBlock.name = "\(self.blockNameFlag)"
            connectingBlock.physicsBody = SKPhysicsBody(rectangleOf: connectingBlock.size)
            connectingBlock.physicsBody?.isDynamic = true
            connectingBlock.physicsBody?.categoryBitMask = Follie.categories.blockCategory.rawValue
            connectingBlock.physicsBody?.contactTestBitMask = Follie.categories.fairyCategory.rawValue | Follie.categories.fairyLineCategory.rawValue
            connectingBlock.physicsBody?.collisionBitMask = 0
            
            let holdBeatNum: Int = Int.random(in: 1 ... self.maxHoldBeat)
            n += Double(holdBeatNum)
            
            let connectingX = blockX + CGFloat(xPerBeat * n)
            let connectingY = CGFloat.random(in: self.fairyMinY ... self.fairyMaxY)
            let connectingDistance = totalDistance + (xPerBeat * n)
            let connectingTime = totalTime + (self.music.secPerBeat * n)
            
            connectingBlock.position = CGPoint(x: connectingX, y: connectingY)
            
            let connectingActions: [SKAction] = [
                SKAction.moveBy(x: CGFloat(-connectingDistance), y: 0, duration: connectingTime),
                SKAction.removeFromParent()
            ]
            connectingBlock.run(SKAction.sequence(connectingActions))
            self.addChild(connectingBlock)
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
            //            let lineY = prevNodePos.y + (connectingY - prevNodePos.y)/2
            let lineDistance = CGFloat(totalDistance) + (lineX - blockX) + dashedLine.frame.width/2
            let lineTime: Double = Double(lineDistance / CGFloat(blockSpeed))
            
            let lineActions: [SKAction] = [
                SKAction.moveBy(x: -lineDistance, y: 0, duration: lineTime),
                SKAction.removeFromParent()
            ]
            dashedLine.run(SKAction.sequence(lineActions))
            self.addChild(dashedLine)
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
        let newHeight: CGFloat = 3
        
        progressLine.size = CGSize(width: newWidth, height: newHeight)
        progressLine.position = CGPoint(x: screenW/2, y: screenH/10*9)
        progressLine.zPosition = Follie.zPos.visibleBlock.rawValue
        progressLine.alpha = 0
        progressLine.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        progressLine.name = "Progress Line inGame"
        self.addChild(progressLine)
        
        let progressNodeTexture = SKTexture(imageNamed: "gameSnowflake")
        self.progressNode = SKSpriteNode(texture: progressNodeTexture)
        
        let newH: CGFloat = 20
        let newW = self.progressNode.size.width * (newH / self.progressNode.size.height)
        self.progressNode.size = CGSize(width: newW, height: newH)
        
        let newX = progressLine.position.x - progressLine.size.width/2
        self.progressNode.position = CGPoint(x: newX, y: progressLine.position.y)
        self.progressNode.zPosition = Follie.zPos.visibleBlock.rawValue
        self.progressNode.alpha = 0
        self.progressNode.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        self.addChild(self.progressNode)
        
        self.progressDistance = progressLine.size.width
    }
    
    func setupLife() {
        let lifeTexture = SKTexture(imageNamed: "lifePiece")
        
        for i in 1 ... Int(self.maxLife) {
            let lifeNode = SKSpriteNode(texture: lifeTexture)
            lifeNode.anchorPoint = CGPoint(x: 0.5, y: -0.1)
            
            let newH: CGFloat = 15
            let newW = lifeNode.size.width * (newH / lifeNode.size.height)
            lifeNode.size = CGSize(width: newW, height: newH)
            
            lifeNode.position = CGPoint(x: self.screenW/10, y: screenH/10*9)
            lifeNode.zPosition = Follie.zPos.visibleBlock.rawValue
            
            let radAngle = CGFloat(72 * -i) * .pi / 180
            lifeNode.run(SKAction.rotate(toAngle: radAngle, duration: 0))
            lifeNode.alpha = 0
            lifeNode.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            
            self.addChild(lifeNode)
            self.lifeArray.append(lifeNode)
            
        }
        self.lifeArray.reverse()
    }
    
    func setupPause() {
        // Pause Button
        let pauseTexture = SKTexture(imageNamed: "Pause Button")
        let pauseButton = SKSpriteNode(texture: pauseTexture)
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: self.screenW/10*9, y: self.screenH/10*9)
        pauseButton.alpha = 0
        pauseButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        self.addChild(pauseButton)
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
        self.addChild(self.screenCover)
    }
    
    func setAurora() {
        self.aurora = Follie.getEmitters().getAurora()
        self.aurora.position = CGPoint(x: (self.fairyNode.position.x - self.fairyNode.size.width/2), y: self.fairyNode.position.y)
        self.aurora.zPosition = self.fairyNode.zPosition
        self.aurora.particleSize = CGSize(width: 50, height: 100)
        self.aurora.particleColorSequence = nil
        self.aurora.particleColorBlendFactorSequence = nil
        
        self.aurora.particleAction = SKAction.fadeAlpha(by: -1, duration: 1)
        self.aurora.particleColor = Follie.auroraColorRotation()
        
        self.hideAurora()
        self.addChild(aurora)
    }
    
    func setFairy() {
        let fairy = Follie.getFairy()
        
        self.fairyMaxY = fairy.maxY
        self.fairyMinY = fairy.minY
        
        self.fairyLine = fairy.fairyLine
        self.fairyNode = fairy.fairyNode
        self.fairyGlow = fairy.fairyGlow
        
        self.addChild(self.fairyLine)
        self.addChild(self.fairyNode)
        self.fairyNode.addChild(self.fairyGlow)
        
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
        
        self.player.setVolume(0, fadeDuration: 6)
        
        self.blockTimer?.invalidate()
        self.blockTimer = nil
        
        self.progressNode.removeAllActions()
    }
    
    func showLoseMenu() {
        let progressLine = self.childNode(withName: "Progress Line inGame")
        progressLine?.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        self.progressNode.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        let pauseButton = self.childNode(withName: "pause")
        pauseButton?.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        
        let chapterTitle = SKLabelNode(fontNamed: "dearJoeII")
        chapterTitle.text = self.chapterTitle
        chapterTitle.fontSize = 100
        chapterTitle.fontColor = UIColor.white
        chapterTitle.position = CGPoint(x: self.screenW/2, y: self.screenH/4*3)
        chapterTitle.alpha = 0
        chapterTitle.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(chapterTitle)
        chapterTitle.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let chapterNumber = SKLabelNode(fontNamed: ".SFUIText")
        chapterNumber.text = "Chapter \(self.chapterNo)"
        chapterNumber.fontSize = 20
        chapterNumber.fontColor = UIColor.white
        chapterNumber.alpha = 0
        chapterNumber.position = CGPoint(x: chapterTitle.position.x, y: chapterTitle.position.y - chapterTitle.frame.height/2 - 10)
        chapterNumber.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(chapterNumber)
        chapterNumber.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let progressBackgroundTexture = SKTexture(imageNamed: "Progress Bar - Pause&End")
        let progressBackground = SKSpriteNode(texture: progressBackgroundTexture)
        let newWidth = self.screenW * 0.7
        let newHeight: CGFloat = 2
        progressBackground.size = CGSize(width: newWidth, height: newHeight)
        progressBackground.position = CGPoint(x: screenW/2, y: screenH/2)
        progressBackground.alpha = 0
        progressBackground.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(progressBackground)
        progressBackground.run(SKAction.fadeAlpha(to: 0.7, duration: 0.5))
        
        
        let snowflakeProgressTexture = SKTexture(imageNamed: "Snowflakes - Pause&End")
        let newH = FollieMainMenu.screenSize.height * 30/396
        let ratio = newH / snowflakeProgressTexture.size().height
        let newW = ratio * snowflakeProgressTexture.size().width
        let snowflakeProgress = SKSpriteNode(texture: snowflakeProgressTexture)
        snowflakeProgress.size = CGSize(width: newW, height: newH)
        
        let percentage = (self.progressNode.position.x - (screenW/2 - self.progressDistance/2)) / self.progressDistance
        
        let newX = progressBackground.position.x - progressBackground.size.width/2 + (CGFloat(percentage) * progressBackground.size.width)
        
        
        snowflakeProgress.position = CGPoint(x: newX, y: progressBackground.position.y)
        snowflakeProgress.zPosition = (Follie.zPos.inGameMenu.rawValue + 1)
        snowflakeProgress.alpha = 0
        self.addChild(snowflakeProgress)
        snowflakeProgress.run(SKAction.fadeAlpha(to: 0.7, duration: 0.5))
        
        let retryTexture = SKTexture(imageNamed: "Retry Button")
        let retry = SKSpriteNode(texture: retryTexture)
        //        let retryWidth: CGFloat = 35
        //        let retryHeight = retry.size.height * (retryWidth / retry.size.width)
        //        retry.size = CGSize(width: retryWidth, height: retryHeight)
        let retryX = progressBackground.position.x + progressBackground.size.width/2 - retry.size.width/2
        retry.position = CGPoint(x: retryX, y: screenH/4)
        retry.alpha = 0
        retry.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(retry)
        retry.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        retry.name = "retry"
        
        let menuTexture = SKTexture(imageNamed: "Back To Main Menu")
        let menu = SKSpriteNode(texture: menuTexture)
        //        let menuWidth: CGFloat = 35
        //        let menuHeight = menu.size.height * (menuWidth / menu.size.width)
        //        menu.size = CGSize(width: menuWidth, height: menuHeight)
        let menuX = progressBackground.position.x - progressBackground.size.width/2 + menu.size.width/2
        menu.position = CGPoint(x: menuX, y: screenH/4)
        menu.alpha = 0
        menu.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(menu)
        menu.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        menu.name = "menu"
    }
    
    func missed() {
        if (self.isLose) {
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
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
        winText.fontSize = 100
        winText.fontColor = UIColor.white
        winText.position = CGPoint(x: self.screenW/2, y: self.screenH/2 + winText.frame.height/2)
        winText.alpha = 0
        winText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(winText)
        winText.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        let tapText = SKLabelNode(fontNamed: ".SFUIText")
        tapText.text = "Tap to continue"
        tapText.fontSize = 20
        tapText.fontColor = UIColor.white
        tapText.position = CGPoint(x: self.screenW/2, y: self.screenH/2 - tapText.frame.height/2)
        tapText.alpha = 0
        tapText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(tapText)
        
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
    
    func showPauseMenu(finished: @escaping () -> Void) {
        self.pauseText = SKLabelNode(fontNamed: "dearJoeII")
        self.pauseText.text = "Paused"
        self.pauseText.fontSize = 40
        self.pauseText.fontColor = UIColor.white
        self.pauseText.position = CGPoint(x: self.screenW/2, y: self.screenH*2/3)
        self.pauseText.alpha = 0
        self.pauseText.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(self.pauseText)
        self.pauseText.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        
        let resumeTexture = SKTexture(imageNamed: "Resume Button")
        self.resumeButton = SKSpriteNode(texture: resumeTexture)
        //        let retryWidth: CGFloat = 35
        //        let retryHeight = retry.size.height * (retryWidth / retry.size.width)
        //        retry.size = CGSize(width: retryWidth, height: retryHeight)
        self.resumeButton.position = CGPoint(x: self.screenW*2/3, y: self.screenH/2)
        self.resumeButton.alpha = 0
        self.resumeButton.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(self.resumeButton)
        self.resumeButton.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        self.resumeButton.name = "resume"
        
        let menuTexture = SKTexture(imageNamed: "Back To Main Menu")
        self.backToMainMenuButton = SKSpriteNode(texture: menuTexture)
        //        let menuWidth: CGFloat = 35
        //        let menuHeight = menu.size.height * (menuWidth / menu.size.width)
        //        menu.size = CGSize(width: menuWidth, height: menuHeight)
        self.backToMainMenuButton.position = CGPoint(x: self.screenW/3, y: self.screenH/2)
        self.backToMainMenuButton.alpha = 0
        self.backToMainMenuButton.zPosition = Follie.zPos.inGameMenu.rawValue
        self.addChild(self.backToMainMenuButton)
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
                    
                    let actions: [SKAction] = [
                        SKAction.fadeIn(withDuration: 0.2),
                        SKAction.fadeOut(withDuration: 0.2)
                    ]
                    self.fairyGlow.run(SKAction.sequence(actions))
                    
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
        
        let actions: [SKAction] = [
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
        ]
        self.fairyGlow.run(SKAction.sequence(actions))
        
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
        
        fadeOutNode.run(SKAction.fadeAlpha(to: 1, duration: 1.0)) {
            let newScene = MainMenu(size: self.size)
            newScene.scaleMode = self.scaleMode
            let animation = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: animation)
        }
        return
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self.scene!)
        let touchedNodes = self.scene!.nodes(at: positionInScene)
        
        if (self.isLose) {
            
            if (self.isDismiss) {
                return
            }
            
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
                        self.addChild(fadeOutNode)
                        
                        fadeOutNode.run(SKAction.fadeAlpha(to: 1, duration: 1.0)) {
                            // Preload animation
                            var preAtlas = [SKTextureAtlas]()
                            preAtlas.append(SKTextureAtlas(named: "Baby"))
                            
                            // Move to next scene
                            SKTextureAtlas.preloadTextureAtlases(preAtlas, withCompletionHandler: { () -> Void in
                                DispatchQueue.main.sync {
                                    let newScene = GameScene(size: self.size)
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
                            self.scene?.isPaused = true
                            self.player.pause()
                            
                            self.pauseTimer()
                        }
                    }
                }
                
                return
            }
            else if (node.name != nil && node.name == "menu") {
                self.run(self.buttonClickedSfx)
                self.scene?.isPaused = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.backToMainMenu()
                }
            }
            else if (node.name != nil && node.name == "resume") {
                self.run(self.buttonClickedSfx)
                self.scene?.isPaused = false
                let goneAction = SKAction.fadeAlpha(to: 0, duration: 0.1)
                self.pauseText.run(goneAction)
                self.backToMainMenuButton.run(goneAction)
                self.resumeButton.run(goneAction)
                self.screenCover.run(goneAction)
                self.player.play()
                
                self.resumeTimer()
                
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
                    // Tutorial 2 baru bisa done kalo udah berhenti
                    if (self.secondTuto == true && self.secondTutoFlag == true) {
                        self.scene?.speed = 1.0
                        
                        self.secondTuto = false
                        self.secondTutoFlag = false
                        
                        self.tutorialText.removeFromParent()
                        self.helpingFingerTap.removeFromParent()
                        self.textHasBeenDisplayed = false
                        
                        self.tutorialText.text = "Try to keep the penguin on the line.\nHold and release at the end of the line"
                        self.thirdTuto = true
                        self.startTutorial3()
                        self.successfulHit()
                    }
                    
                    // Check Tuto 3 (Kalo scenenya uda berhenti baru bisa proceed)
                    if (self.thirdTuto == true && thirdTutoFlag == true) {
                        self.thirdTuto2 = true
                        self.thirdTutoFlag = false
                        self.thirdTuto = false
                        self.successfulHit()
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
                        self.tutorialText.removeFromParent()
                        self.helpingFingerHold.removeFromParent()
                        
                        let action: [SKAction] = [
                            SKAction.wait(forDuration: 2),
                            SKAction.fadeAlpha(to: 1, duration: 0.5),
                            SKAction.wait(forDuration: 2.5),
                            SKAction.fadeAlpha(to: 0, duration: 0.5)
                        ]
                        
                        self.tutorialText.text = "Okay, you're all set!"
                        self.tutorialText.run(SKAction.sequence(action))
                        self.addChild(self.tutorialText)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.tutorialText.text = "You have 5 lives. Try not to miss the beat"
                            self.tutorialText.run(SKAction.sequence(action))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.tutorialText.text = "Every 2 successful hits will regain 1 of your live"
                                self.tutorialText.run(SKAction.sequence(action))
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                                    self.tutorialText.text = "Let's catch the beat with follie!"
                                    self.tutorialText.run(SKAction.sequence(action))
                                    
                                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
                                        self.tutorialText.removeFromParent()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
                                        UserDefaults.standard.set(true, forKey: "TutorialCompleted")
                                        self.onTuto = false
                                        self.startGameplay()
                                    }
                                })
                            }
                        }
                    }
                    
                    self.currBlock.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                    self.isHit = true
                    
                    let actions: [SKAction] = [
                        SKAction.fadeIn(withDuration: 0.2),
                        SKAction.fadeOut(withDuration: 0.2)
                    ]
                    self.fairyGlow.run(SKAction.sequence(actions))
                    
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
                    self.tutorialText.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
                    self.tutorialText.text = "Oops! You've missed the beat. Let's try again"
                    self.tutorialText.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                        self.tutorialText.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1, execute: {
                            self.textHasBeenDisplayed = false
                            self.tutorialText.text = "Try to keep the penguin on the line.\nHold and release at the end of the line"
                            self.tutorialText.removeFromParent()
                            self.tutorialText.alpha = 1.0
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                    
                    let actions: [SKAction] = [
                        SKAction.fadeIn(withDuration: 0.2),
                        SKAction.fadeOut(withDuration: 0.2)
                    ]
                    self.fairyGlow.run(SKAction.sequence(actions))
                    
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
        
        if ((self.scene?.isPaused)!) {
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
        self.blockTimer?.invalidate()
        self.blockTimer = nil
        
        self.diffSec = ((Date().timeIntervalSince1970 * 1000.0) - self.currSec) / 1000
        self.diffSec = self.diffSec.truncatingRemainder(dividingBy: self.music.secPerBeat)
        self.diffSec = self.music.secPerBeat - self.diffSec
    }
    
    func resumeTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.diffSec) {
            self.currSec = Date().timeIntervalSince1970 * 1000.0
            self.blockProjectiles()
            
            self.isCurrentlyPaused = false
            
            self.blockTimer = Timer.scheduledTimer(timeInterval: self.music.secPerBeat, target: self, selector: #selector(self.blockProjectiles), userInfo: nil, repeats: true)
        }
    }
}
