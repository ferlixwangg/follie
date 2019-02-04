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
        1: "Hope"
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
}
