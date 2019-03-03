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
    private let availableChapter: Int = FollieMainMenu.availableChapter
    
    private var sky: SKSpriteNode {
        let skyTexture = SKTexture(imageNamed: "Sky - Main Menu")
        let skyNode = SKSpriteNode(texture: skyTexture)
        
        let scaleRatio: Double = Double(FollieMainMenu.screenSize.height * 2 / skyNode.size.height)
        
        skyNode.size.height = FollieMainMenu.screenSize.height * 2
        skyNode.size.width = CGFloat(Double(skyNode.size.width) * scaleRatio)
        skyNode.position = CGPoint(x: Double(FollieMainMenu.screenSize.width/2), y: 0)
        skyNode.zPosition = FollieMainMenu.zPos.mainMenuSky.rawValue
        
        return skyNode
    } // Sky background
    
    private var gameTitle: SKSpriteNode {
        let gameTitleTexture = SKTexture(imageNamed: "Follie")
        let gameTitleNode = SKSpriteNode(texture: gameTitleTexture)
        
        let newH = FollieMainMenu.screenSize.height * CGFloat(FollieMainMenu.gameTitleRatio)
        let newW = gameTitleNode.size.width * (CGFloat(newH) / gameTitleNode.size.height)
        gameTitleNode.size = CGSize(width: newW, height: newH)
        gameTitleNode.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        
        return gameTitleNode
    } // Game Title Follie
    
    private var ground: SKSpriteNode {
        let groundTexture = SKTexture(imageNamed: "Ground - Main Menu")
        let groundNode = SKSpriteNode(texture: groundTexture)
        
        let newHeight = CGFloat(Double(FollieMainMenu.screenSize.height) * FollieMainMenu.groundRatio)
        groundNode.size.width = groundNode.size.width * (newHeight / groundNode.size.height)
        groundNode.size.height = newHeight
        groundNode.zPosition = FollieMainMenu.zPos.mainMenuGround.rawValue
        
        let newY: CGFloat = -(groundNode.size.height/2) - self.gameTitle.size.height
        groundNode.position = CGPoint(x: Double(groundNode.size.width / 2.0), y: Double(newY))
        return groundNode
    } // Ground
    
    private var chapters: [SKSpriteNode] {
        var chapterNodes: [SKSpriteNode] = []
        let snowTexture = SKTexture(imageNamed: "Snowflakes")
        let snowFrozenTexture = SKTexture(imageNamed: "Snowflakes Frozen")
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
            } else {
                chapterNode.texture = snowFrozenTexture
            }
            
            let xPosition = Double(-self.ground.size.width/2) + Double(FollieMainMenu.screenSize.width/4) - Double(invisibleParentForChapter.size.width/2) + Double((invisibleParentForChapter.size.width * CGFloat(2 * (i-1))))
            let yPosition = Double(self.ground.size.height/2) + Double(invisibleParentForChapter.size.height/2)
            invisibleParentForChapter.position = CGPoint(x: xPosition, y: yPosition)
            
            chapterNodes.append(invisibleParentForChapter)
        }
        
        return chapterNodes
    } // Chapter nodes with parent box
    
    private var dashLine: SKShapeNode {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: 0, y: -(CGFloat(FollieMainMenu.chapterRiseRatio) * FollieMainMenu.screenSize.height)*3/2))
        
        let pattern: [CGFloat] = [6.0, 6.0]
        let dashLineNode = SKShapeNode(path: linePath.cgPath.copy(dashingWithPhase: 6, lengths: pattern))
        dashLineNode.strokeColor = UIColor.white
        dashLineNode.lineWidth = FollieMainMenu.screenSize.height * CGFloat(FollieMainMenu.dashedLineRatio)
        dashLineNode.name = "Dashline"
        
        return dashLineNode
    } // Dash line
    
    private var groundExtension: SKSpriteNode {
        let groundTexture = SKTexture(imageNamed: "Ground - Main Menu")
        let groundExtensionNode = SKSpriteNode(texture: groundTexture)
        let newHeight = CGFloat(Double(FollieMainMenu.screenSize.height) * FollieMainMenu.groundRatio)
        groundExtensionNode.size.width = groundExtensionNode.size.width * (newHeight / groundExtensionNode.size.height)
        groundExtensionNode.size.height = newHeight
        groundExtensionNode.position = CGPoint(x: groundExtensionNode.size.width, y: 0)
        
        return groundExtensionNode
    } // Ground Extension
    
    private var mountain: SKSpriteNode {
        let mountainTexture = SKTexture(imageNamed: "Mountain")
        let mountainNode = SKSpriteNode(texture: mountainTexture)
        mountainNode.name = "Mountain"
        let mountainH = FollieMainMenu.screenSize.height * CGFloat(FollieMainMenu.mountainRatio)
        let mountainW = mountainNode.size.width * (mountainH / mountainNode.size.height)
        
        mountainNode.size = CGSize(width: mountainW, height: mountainH)
        
        let snowFrozenTexture = SKTexture(imageNamed: "Snowflakes Frozen")
        let newH = FollieMainMenu.screenSize.height * CGFloat(FollieMainMenu.chapterNodeRatio)
        let newW = snowFrozenTexture.size().width * (newH / snowFrozenTexture.size().height)
        
        let lastChapterXPositionWithNextSpace = Double(-self.ground.size.width/2) + Double(FollieMainMenu.screenSize.width/4) + Double((newW * CGFloat(2 * 13)))
        
        let mountainX = CGFloat(lastChapterXPositionWithNextSpace) - mountainNode.size.width/2
        let mountainY = self.ground.size.height/2 + mountainNode.size.height/2
        mountainNode.position = CGPoint(x: mountainX, y: mountainY)
        
        return mountainNode
    } // Mountain
    
    private var chapterTitle: SKLabelNode {
        let chapterTitle = SKLabelNode(fontNamed: "dearJoeII")
        chapterTitle.fontSize = CGFloat(80 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        chapterTitle.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/50*31)
        chapterTitle.alpha = 0
        chapterTitle.addChild(self.chapterNumber)
        chapterTitle.zPosition = FollieMainMenu.zPos.mainMenuSettingsButton.rawValue
        
        return chapterTitle
    }
    
    private var chapterNumber: SKLabelNode {
        let chapterNumber = SKLabelNode(fontNamed: ".SFUIText")
        chapterNumber.fontSize = CGFloat(20 * FollieMainMenu.fontSizeRatio) * FollieMainMenu.screenSize.height
        chapterNumber.alpha = 0
        chapterNumber.zPosition = FollieMainMenu.zPos.mainMenuSettingsButton.rawValue
        
        return chapterNumber
    }
    
    private var settingsButton: SKSpriteNode {
        let settingsTexture = SKTexture(imageNamed: "Settings")
        let settingsNode = SKSpriteNode(texture: settingsTexture)
        let settingsNodeHeight = 20/396 * FollieMainMenu.screenSize.height
        let settingsNodeWidth = settingsNode.size.width * (settingsNodeHeight / settingsNode.size.height)
        settingsNode.size = CGSize(width: settingsNodeWidth, height: settingsNodeHeight)
        settingsNode.position = CGPoint(x: 0, y: 0)
        settingsNode.name = "Setings"
        settingsNode.alpha = 0
        
        let invisibleSettingsBox = SKSpriteNode(color: .clear, size: CGSize(width: settingsNodeWidth*3, height: settingsNodeHeight*3))
        invisibleSettingsBox.position = CGPoint(x: FollieMainMenu.screenSize.width/11, y: FollieMainMenu.screenSize.height/10 * 8.5)
        invisibleSettingsBox.name = "Setings"
        invisibleSettingsBox.addChild(settingsNode)
        invisibleSettingsBox.zPosition = FollieMainMenu.zPos.mainMenuSettingsButton.rawValue
        invisibleSettingsBox.alpha = 0
        return invisibleSettingsBox
    }
    
    private var vignetteAnimationTextures: [SKTexture] {
        let vignetteAtlas = SKTextureAtlas(named: "Vignette")
        var vignetteFrames: [SKTexture] = []
        
        let numImages = vignetteAtlas.textureNames.count
        for i in 1...numImages {
            let vignetteTextureName = "Vignette\(i)"
            vignetteFrames.append(vignetteAtlas.textureNamed(vignetteTextureName))
        }
        return vignetteFrames
    } // contains vignette animation textures (picture per frame)
    
    var vignetteNode: SKSpriteNode {
        let firstFrameTexture = self.vignetteAnimationTextures[0]
        let vignette = SKSpriteNode(texture: firstFrameTexture)
        
        let newHeight = FollieMainMenu.screenSize.height
        let newWidth = FollieMainMenu.screenSize.width
        
        vignette.size = CGSize(width: newWidth, height: newHeight)
        vignette.position = CGPoint(x: FollieMainMenu.screenSize.width/2, y: FollieMainMenu.screenSize.height/2)
        
        let action: [SKAction] = [
            SKAction.animate(with: self.vignetteAnimationTextures, timePerFrame: 0.08),
            SKAction.removeFromParent()
        ]
        
        vignette.run(SKAction.sequence(action))
        return vignette
    } // vignette node + its animation

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
        tempNodes.append(self.groundExtension)
        tempNodes.append(self.mountain)
        
        return tempNodes
    } // Ground children
    
    func getVignette() -> SKSpriteNode {
        return self.vignetteNode
    }
    
    func getDashedLines() -> SKShapeNode {
        return self.dashLine
    }
    
    func getSettingsButton() -> SKSpriteNode {
        return self.settingsButton
    }
}
