//
//  Chapter.swift
//  cubeRun
//
//  Created by Steven Muliamin on 26/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

class Chapter {
    init() {}
    
    private let chapterMusic: [Int:Music] = [
        1: Music(name: "DYATHON - Goodbye", secPerBeat: 1)
    ]
    
    private let chapterBlock: [Int:Block] = [
        1: Block(name: "Star")
    ]
    
    private let chapterTitle: [Int:String] = [
        1: "Hope",
        2: "Blooming Romance"
    ]
    
    private let chapterBackground: [Int:Background] = [
        1: Background(skyName: "Sky", backgroundName: "Ground", bg1Name: "Background1", bg2Name: "Background2")
    ]
    
    func getMusic(chapterNo: Int) -> Music {
        return self.chapterMusic[chapterNo]!
    }
    
    func getBlock(chapterNo: Int) -> Block {
        return self.chapterBlock[chapterNo]!
    }
    
    func getTitle(chapterNo: Int) -> String {
        return self.chapterTitle[chapterNo]!
    }
    
    func getBackgroundNodes(chapterNo: Int) -> [SKSpriteNode] {
        return self.chapterBackground[chapterNo]!.getAllBackgroundNodes()
    }
}
