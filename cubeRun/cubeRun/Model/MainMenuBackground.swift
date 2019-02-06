//
//  MainMenuBackground.swift
//  cubeRun
//
//  Created by Ferlix Yanto Wang on 01/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

class MainMenuBackground {
    init() {}
    
    // Constants
    private let mainMenuAtlas = SKTextureAtlas(named: "Main Menu")
    private let availableChapter: Int = UserDefaults.standard.integer(forKey: "AvailableChapter")
    
    private var sky: SKSpriteNode {
        let skyTexture = self.mainMenuAtlas.textureNamed("Sky - Main Menu")
        let skyNode = SKSpriteNode(texture: skyTexture)
        
        let scaleRatio: Double = Double(FollieMainMenu.screenSize.height * 2 / skyNode.size.height)
        
        skyNode.size.height = FollieMainMenu.screenSize.height * 2
        skyNode.size.width = CGFloat(Double(skyNode.size.width) * scaleRatio)
        skyNode.position = CGPoint(x: Double(FollieMainMenu.screenSize.width/2), y: 0)
        skyNode.zPosition = FollieMainMenu.zPos.mainMenuSky.rawValue
        
        return skyNode
    } // Sky background
    
    private var gameTitle: SKSpriteNode {
        let gameTitleTexture = self.mainMenuAtlas.textureNamed("Follie")
        let gameTitleNode = SKSpriteNode(texture: gameTitleTexture)
        gameTitleNode.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        
        return gameTitleNode
    } // Game Title Follie
    
    private var ground: SKSpriteNode {
        let groundTexture = self.mainMenuAtlas.textureNamed("Ground - Main Menu")
        let groundNode = SKSpriteNode(texture: groundTexture)
        groundNode.size.height = CGFloat(Double(FollieMainMenu.screenSize.height) * FollieMainMenu.groundRatio)
        groundNode.size.width = CGFloat(Double(groundNode.size.width) * FollieMainMenu.groundRatio)
        groundNode.zPosition = FollieMainMenu.zPos.mainMenuGroundAndSnow.rawValue
        
        let newY: CGFloat = -(groundNode.size.height/2) - self.gameTitle.size.height
        groundNode.position = CGPoint(x: Double(groundNode.size.width / 2.0), y: Double(newY))
        
        return groundNode
    } // Ground
    
    private var chapters: [SKSpriteNode] {
        var chapterNodes: [SKSpriteNode] = []
        let snowTexture = self.mainMenuAtlas.textureNamed("Snowflakes")
        let snowFrozenTexture = self.mainMenuAtlas.textureNamed("Snowflakes Frozen")
        let newH = FollieMainMenu.screenSize.height * CGFloat(FollieMainMenu.chapterNodeRatio)
        let ratio = newH / snowFrozenTexture.size().height
        let newW = ratio * snowFrozenTexture.size().width
        
        for i in 1 ... 12   {
            let chapterNode = SKSpriteNode()
            chapterNode.size = CGSize(width: newW, height: newH)
            
            let invisibleParentForChapter = SKSpriteNode(color: UIColor.clear, size: CGSize(width: newW, height: newH))
            invisibleParentForChapter.name = "Chapter\(i)"
            invisibleParentForChapter.zPosition = FollieMainMenu.zPos.mainMenuChapterNode.rawValue
            invisibleParentForChapter.addChild(chapterNode)
            
            if i <= availableChapter{
                chapterNode.texture = snowTexture
                invisibleParentForChapter.addChild(dashLine)
            } else {
                chapterNode.texture = snowFrozenTexture
            }
            
            let xPosition = Double(-self.ground.size.width/2) + Double(FollieMainMenu.screenSize.width/6) - Double(invisibleParentForChapter.size.width/2) + Double((invisibleParentForChapter.size.width * CGFloat(2 * (i-1))))
            let yPosition = Double(self.ground.size.height/2) + Double(invisibleParentForChapter.size.height/2)
            invisibleParentForChapter.position = CGPoint(x: xPosition, y: yPosition)
            
            chapterNodes.append(invisibleParentForChapter)
        }
        
        return chapterNodes
    } // Chapter nodes with parent box
    
    private var dashLine: SKShapeNode {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: 0, y: -(CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height)*2))
        
        let pattern: [CGFloat] = [6.0, 6.0]
        let dashLineNode = SKShapeNode(path: linePath.cgPath.copy(dashingWithPhase: 6, lengths: pattern))
        dashLineNode.strokeColor = UIColor.white
        dashLineNode.lineWidth = 3
        
        return dashLineNode
    } // Dash line
    
    private var groundExtension1: SKSpriteNode {
        let groundTexture = self.mainMenuAtlas.textureNamed("Ground")
        let groundExtensionNode = SKSpriteNode(texture: groundTexture)
        groundExtensionNode.size.height = CGFloat(Double(FollieMainMenu.screenSize.height) * FollieMainMenu.groundRatio)
        groundExtensionNode.size.width = CGFloat(Double(groundExtensionNode.size.width) * FollieMainMenu.groundRatio)
        groundExtensionNode.zPosition = FollieMainMenu.zPos.mainMenuGroundAndSnow.rawValue
        groundExtensionNode.position = CGPoint(x: groundExtensionNode.size.width, y: 0)
        
        return groundExtensionNode
    } // Ground Extension 1
    
    private var groundExtension2: SKSpriteNode {
        let groundTexture = self.mainMenuAtlas.textureNamed("Ground")
        let groundExtensionNode = SKSpriteNode(texture: groundTexture)
        groundExtensionNode.size.height = CGFloat(Double(FollieMainMenu.screenSize.height) * FollieMainMenu.groundRatio)
        groundExtensionNode.size.width = CGFloat(Double(groundExtensionNode.size.width) * FollieMainMenu.groundRatio)
        groundExtensionNode.zPosition = FollieMainMenu.zPos.mainMenuGroundAndSnow.rawValue
        groundExtensionNode.position = CGPoint(x: groundExtensionNode.size.width * 2, y: 0)
        
        return groundExtensionNode
    } // Ground Extension 2
    
    private var mountain: SKSpriteNode {
        let mountainTexture = self.mainMenuAtlas.textureNamed("Mountain")
        let mountainNode = SKSpriteNode(texture: mountainTexture)
        mountainNode.name = "Mountain"
        mountainNode.setScale(0.7)
        
        let mountainX = (-self.ground.size.width/2) + (2*self.ground.size.width) - (mountainNode.size.width/2)
        let mountainY = self.ground.size.height/2 + mountainNode.size.height/2
        mountainNode.position = CGPoint(x: mountainX, y: mountainY)
        
        return mountainNode
    } // Mountain
    
    private var chapterTitle: SKLabelNode {
        let chapterTitle = SKLabelNode(fontNamed: "dearJoeII")
        chapterTitle.fontSize = 100
        chapterTitle.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/3*2)
        chapterTitle.alpha = 0
        chapterTitle.addChild(self.chapterNumber)
        chapterTitle.zPosition = 10
        
        return chapterTitle
    }
    
    private var chapterNumber: SKLabelNode {
        let chapterNumber = SKLabelNode(fontNamed: "Roboto-Regular")
        chapterNumber.fontSize = 20
        chapterNumber.alpha = 0
        
        return chapterNumber
    }
    
    // Getters
    func getSkyNode() -> SKSpriteNode {
        return self.sky
    }
    
    func getGameTitleNode() -> SKSpriteNode {
        return self.gameTitle
    }
    
    func getGroundNode() -> SKSpriteNode {
        return self.ground
    }
    
    func getChapterTitle() -> SKLabelNode {
        return self.chapterTitle
    }
    
    func getGroundChildNodes() -> [SKSpriteNode] {
        var tempNodes: [SKSpriteNode] = []
        
        tempNodes.append(contentsOf: self.chapters)
        tempNodes.append(self.groundExtension1)
        tempNodes.append(self.groundExtension2)
        tempNodes.append(self.mountain)
        
        return tempNodes
    } // Ground children
}
