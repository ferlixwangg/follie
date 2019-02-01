//
//  GameScene.swift
//  cubeRun
//
//  Created by Steven Muliamin on 09/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Current chapter
    var chapterNo: Int = 1
    
    // Screen size
    var screenW: CGFloat!
    var screenH: CGFloat!
    
    // Fairy objects and attributes
    var fairyLine: SKSpriteNode!
    var fairyNode: SKSpriteNode!
    var fairyGlow: SKSpriteNode!
    var fairyMaxY: CGFloat!
    var fairyMinY: CGFloat!
    
    // Emitters
    var aurora: SKEmitterNode!
    
    // Music and Block
    var music: Music!
    var musicAction: SKAction!
    var block: Block!
    var blockTexture: SKTexture!
    var blockTimer: Timer!
    
    // Gameplay logic
    var nextCountdown: Int = 0 // new block will appear when countdown reaches 0
    var blockNameFlag: Int = 0 // incremental flag to give each block a unique name identifier
    let maxInterval: Int = 1 // max beat interval between blocks
    let maxHoldNum: Int = 4 // max number of connected blocks (hold gesture)
    let maxHoldBeat: Int = 2 // max number of beats in one hold gesture between 2 blocks
    let holdChance: Double = 4/10 // percentage of connecting blocks appearing
    var currBlockNameFlag: Int = 0 // name flag of closest block to reach the fairy
    
    var currBlock: SKSpriteNode! // name of closest block node to reach fairy
    var currLine: SKShapeNode! // name of closest connecting line node to reach fairy
    var isBlockContact: Bool = false // whether block node is currently in contact with fairy
    var isLineContact: Bool = false // whether connecting line node is currently in contact with fairy
    var isHit: Bool = false // whether the player has successfully hit the passing block
    var isHolding: Bool = false // whether the player is holding
    
    var upcomingLines: [SKShapeNode] = [] // list of upcoming lines from the closest
    var isAtLine: Bool = false // whether fairy is currently at line
    
    override func didMove(to view: SKView) {
        self.initialSetup()
        self.startGameplay()
    }
    
    func initialSetup() {
        // Set initial physics world (to enable collision check)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.setScreenSize()
        
        self.setBackground()
        self.setFairy()
        self.setAurora()
        
        self.setChapter()
    } // setup before gameplay starts (load and put in place all nodes)
    
    func setChapter() {
        let chapter = Follie.getChapter()
        
        self.music = chapter.getMusic(chapterNo: self.chapterNo)
        self.block = chapter.getBlock(chapterNo: self.chapterNo)
        
        self.musicAction = SKAction.playSoundFileNamed(self.music.name, waitForCompletion: false)
        
        self.blockTexture = SKTexture(imageNamed: self.block.name)
    }
    
    func startGameplay() {
        self.run(self.musicAction)
        
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
    
    func setScreenSize() {
        self.screenH = Follie.screenSize.height
        self.screenW = Follie.screenSize.width
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
    
    func setBackground() {
        let tempBackground = Follie.getBackground()
        let tempNodes = tempBackground.getAllBackgroundNodes()
        
        for node in tempNodes {
            self.addChild(node)
        }
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
        self.aurora.particleBirthRate = 0
        
    }
    
    func showAurora() {
        self.aurora.particleBirthRate = 15
        self.changeAuroraColor()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact fairy & block
            //            print("allow hit")
            var block: SKSpriteNode!
            
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            if (block.name == "\(self.currBlockNameFlag)") {
                self.currBlock = block
                self.isBlockContact = true
            }
        }
        else if ((contact.bodyA.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.holdLineCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.holdLineCategory.rawValue)) {
            // contact fairyLine & line
            var line: SKShapeNode!
            
            if (contact.bodyA.categoryBitMask == Follie.categories.holdLineCategory.rawValue) {
                // bodyA is line
                line = (contact.bodyA.node as! SKShapeNode)
            }
            else {
                // bodyB is line
                line = (contact.bodyB.node as! SKShapeNode)
            }
            
            
            if (self.currLine == nil){
                self.currLine = line
            }
            else if (Int(line.name!)! < self.currBlockNameFlag) {
                self.currLine = line
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyLineCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact end fairyLine & block
            var block: SKSpriteNode!
            //            print("miss")
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            if (block.name == "\(self.currBlockNameFlag)") {
                self.currBlockNameFlag += 1
            }
            
            if (!self.isHit) {
                self.hideAurora()
                
                if (self.upcomingLines.first?.name == "\(self.currBlockNameFlag)") {
                    // check whether missed block is connected by a line
                    self.upcomingLines.first?.run(SKAction.fadeOut(withDuration: 0.3))
                    self.upcomingLines.first?.strokeColor = SKColor.red
                    self.upcomingLines.remove(at: 0)
                }
            }
            
            self.isHit = false
        }
        else if ((contact.bodyA.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyB.categoryBitMask == Follie.categories.blockCategory.rawValue) || (contact.bodyB.categoryBitMask == Follie.categories.fairyCategory.rawValue && contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue)) {
            // contact end fairy & block
            var block: SKSpriteNode!
            //            print("dont allow hit")
            if (contact.bodyA.categoryBitMask == Follie.categories.blockCategory.rawValue) {
                // bodyA is block
                block = (contact.bodyA.node as! SKSpriteNode)
            }
            else {
                // bodyB is block
                block = (contact.bodyB.node as! SKSpriteNode)
            }
            
            if (block.name == "\(self.currBlockNameFlag)") {
                self.currBlock = nil
                self.isBlockContact = false
            }
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
            
            if (self.isAtLine && (line.name == self.currLine.name)) {
                if (self.currBlock.name == line.name) {
                    return
                }
                //                print("end is atline \(line.name)")
                self.isAtLine = false
                line.run(SKAction.fadeOut(withDuration: 0.3))
                line.strokeColor = SKColor.red
                self.currLine = self.upcomingLines.first
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        if (point.x > screenW/2) {
            // touch right part of the screen start
            self.isHolding = true
            
            if (self.isBlockContact && !self.isHit) {
                // successfully hit
                self.isHit = true
                self.currBlock.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                
                let actions: [SKAction] = [
                    SKAction.fadeIn(withDuration: 0.2),
                    SKAction.fadeOut(withDuration: 0.2)
                ]
                self.fairyGlow.run(SKAction.sequence(actions))
                
                self.showAurora()
                
                if (self.upcomingLines.first?.name == "\(Int(self.currBlock.name!)!+1)") {
                    // hit connecting block
                    self.isAtLine = true
                    self.currLine = self.upcomingLines.first
                    self.upcomingLines.first?.zPosition = Follie.zPos.hiddenBlockArea.rawValue
                    self.upcomingLines.remove(at: 0)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        if (point.x > screenW/2) {
            // touch right part of the screen ends
            self.isHolding = false
            
            if (self.isAtLine) {
                self.isAtLine = false
                self.currLine.run(SKAction.fadeOut(withDuration: 0.3))
                self.currLine.strokeColor = SKColor.red
                self.currLine = self.upcomingLines.first
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let point = touch.location(in: self)
            
            // if left screen
            if (point.x < screenW/2) {
                let prevPoint = touch.previousLocation(in: self)
                
                let yMovement = point.y - prevPoint.y
                var newPositionY = self.fairyNode.position.y + yMovement
                
                if (newPositionY > self.fairyMaxY) {
                    newPositionY = self.fairyMaxY
                }
                else if (newPositionY < self.fairyMinY) {
                    newPositionY = self.fairyMinY
                }
                self.aurora.particlePosition.y = self.aurora.particlePosition.y + (newPositionY - self.fairyNode.position.y)
                self.fairyNode.position.y = newPositionY
            }
        }
    }
}
