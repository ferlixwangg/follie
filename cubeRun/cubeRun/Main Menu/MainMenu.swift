//
//  MainMenu.swift
//  cubeRun
//
//  Created by Ferlix Yanto Wang on 01/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    // Main Menu Assets Atlas
    private let mainMenuAtlas = SKTextureAtlas(named: "Main Menu")
    
    /// UserDefault value of the unlocked chapters
    let availableChapter: Int = UserDefaults.standard.integer(forKey: "AvailableChapter")
    
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
    
    // Variables for flag to detect selected chapter
    var activeChapter = SKSpriteNode()
    var activeChapterName = String()
    
    // Camera Down Animation elements
    var cameraDownOnGoing: Bool!
    var skyFinalY: CGFloat!
    var gameTitalFinalY: CGFloat!
    var groundFinalY: CGFloat!
    
    // DispatchWorkTask for ChapterTitle Animation
    var task: DispatchWorkItem!
    
    // To disable the chances of tapping chapter multiple times
    var chapterChosen: Bool!
    
    override func didMove(to view: SKView) {
        let showFollieTitle = FollieMainMenu.showFollieTitle
        
        if (showFollieTitle == true) {
            self.initialVignette()
        }
        
        self.setNodes()
        self.snowEmitter()
        self.startBackgroundMusic()
        
        if (showFollieTitle == true) {
            self.cameraDownOnGoing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if (self.cameraDownOnGoing == true) {
                    self.cameraDownAnimation()
                }
            }
            self.setActiveChapter(duration: 5.5)
        } else {
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
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + durationStartDispatch, execute: self.task)
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
        chapterNumber.position = CGPoint(x: 0, y: -self.chapterTitle.frame.height/2 - 20)
        
        moveChapterTitleAndNumber(durationStartDispatch: duration)
        
        // Snowflakes go up
        let chapterSnowflake = self.activeChapter.children[0] as! SKSpriteNode
        self.activeChapter.run(SKAction.moveBy(x: 0, y: CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height, duration: 0))
        chapterSnowflake.run(SKAction.repeatForever(SKAction.rotate(byAngle: -0.5, duration: 1)), withKey: "repeatForeverActionKey")
        
        // Apply glowing effect on the snowflake
        let glow = SKSpriteNode(texture: mainMenuAtlas.textureNamed("Fairy Glow"))
        let glowSize = chapterSnowflake.size.width+15
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
        let tempBackground = FollieMainMenu.getMainMenuBackground()
        
        self.sky = tempBackground.getSkyNode()
        self.addChild(self.sky)
        
        self.gameTitle = tempBackground.getGameTitleNode()
        self.addChild(self.gameTitle)
        
        self.ground = tempBackground.getGroundNode()
        self.addChild(self.ground)
        
        self.chapterTitle = tempBackground.getChapterTitle()
        self.addChild(self.chapterTitle)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (self.chapterChosen) {
            return
        }
        
        // Obtain the node that is touched
        let touch: UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self.ground)
        let touchedNodes = self.ground.nodes(at: positionInScene)
        
        if (self.cameraDownOnGoing == true) {
            self.gameTitle.removeAllActions()
            self.ground.removeAllActions()
            self.sky.removeAllActions()
            self.task.cancel()
            self.moveChapterTitleAndNumber(durationStartDispatch: 0.5)
            self.beginMoveByAnimation(goUpDuration: 1)
            self.cameraDownOnGoing = false
        }
        
        for node in touchedNodes {
            // Check if the selected node is the chapter node
            if (node.name != nil && node.name!.contains("Chapter")) {
                
                // Check the chapter number using substring
                let start = node.name!.index(node.name!.startIndex, offsetBy: 7)
                let end = node.name!.endIndex
                let range = start..<end
                let index = Int(node.name![range])
                
                // Check whether the selected chapter is already unlocked
                if (index! <= self.availableChapter) {
                    
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
                        node.run(SKAction.moveBy(x: 0, y: CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height, duration: 0.5))
                        chapterSnowflake.run(SKAction.repeatForever(SKAction.rotate(byAngle: -0.5, duration: 1)), withKey: "repeatForeverActionKey")
                        
                        // Play Sound Effect
                        self.run(self.clickedChapterSfx)
                        
                        // Apply glowing effect on the snowflake
                        let glow = SKSpriteNode(texture: mainMenuAtlas.textureNamed("Fairy Glow"))
                        let glowSize = chapterSnowflake.size.width+15
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
                                    let transition = SKTransition.fade(withDuration: 1)
                                    if let scene = SKScene(fileNamed: "GameScene") {
                                        scene.scaleMode = .aspectFill
                                        self.view?.presentScene(scene, transition: transition)
                                    }
                                }
                            })
                        }
                    }
                } else {
                    let unavailableNode = SKLabelNode(text: "This chapter is not unlocked yet")
                    unavailableNode.fontColor = UIColor.white
                    unavailableNode.fontName = ".SFUIText"
                    unavailableNode.fontSize = 14
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
        for touch in touches{
            let point = touch.location(in: self)
            
            let prevPoint = touch.previousLocation(in: self)
            let xMovement = point.x - prevPoint.x
            let newPositionX = self.ground.position.x + xMovement
            
            if (newPositionX < -(self.ground.size.width/2)) {
                self.ground.position.x = -(self.ground.size.width/2)
            } else if (newPositionX > self.ground.size.width/2) {
                self.ground.position.x = self.ground.size.width/2
            } else {
                self.ground.position.x = newPositionX
            }
        }
    }
}
