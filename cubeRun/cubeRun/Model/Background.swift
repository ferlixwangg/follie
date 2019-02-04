//
//  Background.swift
//  cubeRun
//
//  Created by Steven Muliamin on 24/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains all background elements and animations
class Background {
    init() {}
    
    private var sky: SKSpriteNode {
        let skyTexture = SKTexture(imageNamed: "Sky")
        let skyNode = SKSpriteNode(texture: skyTexture)
        
        skyNode.size = Follie.screenSize
        skyNode.position = CGPoint(x: Follie.screenSize.width/2, y: Follie.screenSize.height/2)
        skyNode.zPosition = FollieMainMenu.zPos.sky.rawValue
        
        return skyNode
    } // Sky background (static)
    
    private var hiddenSky: SKSpriteNode {
        let hiddenSkyTexture = SKTexture(imageNamed: "Sky")
        let hiddenSkyNode = SKSpriteNode(texture: hiddenSkyTexture)
        
        hiddenSkyNode.size = CGSize(width: Follie.screenSize.width * CGFloat(Follie.hiddenSkyX), height: Follie.screenSize.height)
        hiddenSkyNode.position = CGPoint(x: hiddenSkyNode.size.width/2, y: Follie.screenSize.height/2)
        hiddenSkyNode.zPosition = Follie.zPos.hiddenSky.rawValue
        
        return hiddenSkyNode
    } // Sky background (static)
    
    private var grounds: [SKSpriteNode] {
        let groundTexture = SKTextureAtlas(named: "Main Menu").textureNamed("Ground")
        var tempGrounds: [SKSpriteNode] = []
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            
            let newHeight = CGFloat(Double(Follie.screenSize.height) * Follie.groundRatio)
            let newWidth = ground.size.width * (newHeight / ground.size.height)
            
            ground.size = CGSize(width: newWidth, height: newHeight)
            ground.zPosition = Follie.zPos.ground.rawValue

            let newY: CGFloat = CGFloat(Double(Follie.screenSize.height) * Follie.groundRatio) - ground.size.height/2
            ground.position = CGPoint(x: (ground.size.width / 2.0 + (ground.size.width * CGFloat(i)) - (CGFloat(i))), y: newY)

            let time: Double = Double(ground.size.width)/Follie.xSpeed

            let moveLeft = SKAction.moveBy(x: -ground.size.width, y: 0, duration: time)
            let moveReset = SKAction.moveBy(x: ground.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
            tempGrounds.append(ground)
        }
        return tempGrounds
    } // Moving ground
    
    private var background1s: [SKSpriteNode] {
        let background1Texture = SKTexture(imageNamed: "Background1")
        var tempBackground1s: [SKSpriteNode] = []
        
        for i in 0 ... 1 {
            let background1 = SKSpriteNode(texture: background1Texture)
            
            let newHeight = CGFloat(Double(Follie.screenSize.height) * Follie.backgroundRatio)
            let newWidth = background1.size.width * (newHeight / background1.size.height)
            
            background1.size = CGSize(width: newWidth, height: newHeight)
            background1.zPosition = Follie.zPos.background1.rawValue
    
            let newY: CGFloat = CGFloat(Double(Follie.screenSize.height) * Follie.groundRatio + Double(background1.size.height/2))
            background1.position = CGPoint(x: (background1.size.width / 2.0 + (background1.size.width * CGFloat(i))), y: CGFloat(newY))
            
            let time: Double = Double(background1.size.width)/Follie.xSpeed
            
            let moveLeft = SKAction.moveBy(x: -background1.size.width, y: 0, duration: time)
            let moveReset = SKAction.moveBy(x: background1.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background1.run(moveForever)
            tempBackground1s.append(background1)
        }
        return tempBackground1s
    } // Moving background (background1)
    
    private var background2s: [SKSpriteNode] {
        let background2Texture = SKTexture(imageNamed: "Background2")
        var tempBackground2s: [SKSpriteNode] = []
        
        for i in 0 ... 1 {
            let background2 = SKSpriteNode(texture: background2Texture)
            
            let newHeight = CGFloat(Double(Follie.screenSize.height) * Follie.backgroundRatio)
            let newWidth = background2.size.width * (newHeight / background2.size.height)
            
            background2.size = CGSize(width: newWidth, height: newHeight)
            background2.zPosition = Follie.zPos.background2.rawValue
            
            let newY: CGFloat = CGFloat(Double(Follie.screenSize.height) * Follie.groundRatio + Double(background2.size.height/2))
            background2.position = CGPoint(x: (background2.size.width / 2.0 + (background2.size.width * CGFloat(i))), y: CGFloat(newY))
            
            let time: Double = Double(background2.size.width)/(Follie.xSpeed * 1/2)
            
            let moveLeft = SKAction.moveBy(x: -background2.size.width, y: 0, duration: time)
            let moveReset = SKAction.moveBy(x: background2.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background2.run(moveForever)
            tempBackground2s.append(background2)
        }
        return tempBackground2s
    } // Moving background (background2)
    
    func getAllBackgroundNodes() -> [SKSpriteNode] {
        var tempNodes: [SKSpriteNode] = []
        
        tempNodes.append(self.sky)
        tempNodes.append(self.hiddenSky)
        tempNodes.append(contentsOf: self.grounds)
        tempNodes.append(contentsOf: self.background1s)
        tempNodes.append(contentsOf: self.background2s)
        
        return tempNodes
    } // All background nodes combined
}
