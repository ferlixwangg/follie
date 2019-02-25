//
//  Fairy.swift
//  cubeRun
//
//  Created by Steven Muliamin on 24/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

// Contains all fairy elements and attributes
class Fairy {
    init() {}
    
    private let fairyLineTopPaddingRatio: Double = 1/10 // padding from device top screen to maximum fairy height
    
    private let fairyLineRatio: Double = 1/2 // fairy line height ratio to the screen height (allowable fairy movement)
    
    private let fairyLinePositionXRatio: Double = Follie.hiddenSkyX // fairy line x-position ratio to the screen width
    
    private let fairyNodeRatio : Double = 50/396 // Fairy size ratio
    
    private var fairyHeight: CGFloat {
        return Follie.screenSize.height * CGFloat(fairyNodeRatio)
    }
    
    var fairyLine: SKSpriteNode {
        let fairyLineTexture = SKTexture(imageNamed: "fairyLine")
        let fairyLine = SKSpriteNode(texture: fairyLineTexture)
        
        fairyLine.size.height = Follie.screenSize.height * CGFloat(self.fairyLineRatio)
        fairyLine.size.width = 2
        
        let lineX = Follie.screenSize.width * CGFloat(self.fairyLinePositionXRatio)
        let lineY = Follie.screenSize.height - fairyLine.frame.height/2 - (Follie.screenSize.height * CGFloat(self.fairyLineTopPaddingRatio))
        
        fairyLine.position = CGPoint(x: lineX, y: lineY)
        fairyLine.alpha = 0
        fairyLine.zPosition = Follie.zPos.fairyLine.rawValue
        
        return fairyLine
    } // the specified line/path the fairy is allowed to move around in
    
    private var fairyAnimationTextures: [SKTexture] {
        let fairyAtlas = SKTextureAtlas(named: "Baby")
        var fairyFrames: [SKTexture] = []
        
        let numImages = fairyAtlas.textureNames.count
        for i in 1...numImages {
            let fairyTextureName = "Baby\(i)"
            fairyFrames.append(fairyAtlas.textureNamed(fairyTextureName))
        }
        return fairyFrames
    } // contains fairy animation textures (picture per frame)
    
    var fairyNode: SKSpriteNode {
        let firstFrameTexture = self.fairyAnimationTextures[0]
        let fairy = SKSpriteNode(texture: firstFrameTexture)
        
        let newHeight = self.fairyHeight
        let newWidth = fairy.size.width * (newHeight / fairy.size.height)
        
        fairy.size = CGSize(width: newWidth, height: newHeight)
        fairy.position = self.fairyLine.position
        fairy.zPosition = Follie.zPos.fairy.rawValue
        
        fairy.run(SKAction.repeatForever(
            SKAction.animate(with: self.fairyAnimationTextures,
                             timePerFrame: 0.04,
                             resize: false,
                             restore: true)),
                  withKey:"fairyAnimation")
        
        return fairy
    } // fairy node + its animation
    
    var maxY: CGFloat {
        return self.fairyLine.position.y + self.fairyLine.size.height/2 - self.fairyNode.size.height/2
    } // max y-position for fairyNode
    
    var minY: CGFloat {
        return self.fairyLine.position.y - self.fairyLine.size.height/2 + self.fairyNode.size.height/2
    } // min y-position for fairyNode
}
