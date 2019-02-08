//
//  Chapter.swift
//  cubeRun
//
//  Created by Steven Muliamin on 26/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import SpriteKit

class Chapter {
    init(chapterNo: Int) {
       self.chapterNo = chapterNo
    }
    
    var chapterNo: Int
    
    private let chapterMusic: [Int:Music] = [
        1: Music(name: "DYATHON - Your Eyes", secPerBeat: (Double(60)/Double(78))),
        2: Music(name: "DYATHON - Blooming Romance", secPerBeat: (Double(60)/Double(89)))
    ]
    
    private let chapterTitle: [Int:String] = [
        1: "Your Eyes",
        2: "Blooming Romance"
    ]
    
    private let chapterBackground: [Int:Background] = [
        1: Background(skyName: "Sky", backgroundName: "Ground", bg1Name: "Background1", bg2Name: "Background2"),
        2: Background(skyName: "Sky", backgroundName: "Ground", bg1Name: "Background1", bg2Name: "Background2")
    ]
    
    func getMusic() -> Music {
        return self.chapterMusic[self.chapterNo]!
    }
    
    func getTitle() -> String {
        return self.chapterTitle[self.chapterNo]!
    }
    
    func getBackgroundNodes() -> [SKSpriteNode] {
        return self.chapterBackground[self.chapterNo]!.getAllBackgroundNodes()
    }
}
