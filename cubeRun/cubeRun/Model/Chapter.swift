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
        1: Music(name: "#1 - DYATHON - Your Eyes", bpm: 78, beats: chapter1().beats),
        2: Music(name: "#2 - DYATHON - Blooming Romance", bpm: 89, beats: chapter2().beats),
        3: Music(name: "#3 - DYATHON - Emoticon", bpm: 89, beats: []),
        4: Music(name: "#4 - DYATHON - Hope", bpm: 90, beats: []),
        5: Music(name: "#5 - DYATHON - Falling", bpm: 92, beats: []),
        6: Music(name: "#6 - DYATHON - Solitude", bpm: 100, beats: []),
        7: Music(name: "#7 - DYATHON - Insane", bpm: 100, beats: []),
        8: Music(name: "#8 - DYATHON - The Poetry of Your Heart", bpm: 112, beats: []),
        9: Music(name: "#9 - DYATHON - I Need You Here", bpm: 116, beats: []),
        10: Music(name: "#10 - DYATHON - She Loves You", bpm: 132, beats: []),
        11: Music(name: "#11 - DYATHON - I Saw You in a Dream", bpm: 132, beats: []),
        12: Music(name: "#12 - DYATHON - Dear Sister", bpm: 136, beats: [])
    ]
    
    private let chapterTitle: [Int:String] = [
        1: "Your Eyes",
        2: "Blooming Romance",
        3: "Emoticon",
        4: "Hope",
        5: "Falling",
        6: "Solitude",
        7: "Insane",
        8: "The Poetry of Your Heart",
        9: "I Need You Here",
        10: "She Loves You",
        11: "I Saw You in a Dream",
        12: "Dear Sister"
    ]
    
    private let chapterBackground: [Int:Background] = [
        1: Background(skyName: "1-Sky", hiddenSkyName: "1-HiddenSky", backgroundName: "1-Ground", bg1Name: "1-Background1", bg2Name: "1-Background2"),
        2: Background(skyName: "2-Sky", hiddenSkyName: "2-HiddenSky", backgroundName: "2-Ground", bg1Name: "2-Background1", bg2Name: "2-Background2"),
        3: Background(skyName: "3-Sky", hiddenSkyName: "3-HiddenSky", backgroundName: "3-Ground", bg1Name: "3-Background1", bg2Name: "3-Background2"),
        4: Background(skyName: "4-Sky", hiddenSkyName: "4-HiddenSky", backgroundName: "4-Ground", bg1Name: "4-Background1", bg2Name: "4-Background2"),
        5: Background(skyName: "5-Sky", hiddenSkyName: "5-HiddenSky", backgroundName: "5-Ground", bg1Name: "5-Background1", bg2Name: "5-Background2"),
        6: Background(skyName: "6-Sky", hiddenSkyName: "6-HiddenSky", backgroundName: "6-Ground", bg1Name: "6-Background1", bg2Name: "6-Background2"),
        7: Background(skyName: "7-Sky", hiddenSkyName: "7-HiddenSky", backgroundName: "7-Ground", bg1Name: "7-Background1", bg2Name: "blank"),
        8: Background(skyName: "8-Sky", hiddenSkyName: "8-HiddenSky", backgroundName: "8-Ground", bg1Name: "8-Background1", bg2Name: "8-Background2"),
        9: Background(skyName: "9-Sky", hiddenSkyName: "9-HiddenSky", backgroundName: "9-Ground", bg1Name: "9-Background1", bg2Name: "9-Background2"),
        10: Background(skyName: "10-Sky", hiddenSkyName: "10-HiddenSky", backgroundName: "10-Ground", bg1Name: "10-Background1", bg2Name: "blank"),
        11: Background(skyName: "11-Sky", hiddenSkyName: "11-HiddenSky", backgroundName: "11-Ground", bg1Name: "11-Background1", bg2Name: "11-Background2"),
        12: Background(skyName: "12-Sky", hiddenSkyName: "12-HiddenSky", backgroundName: "12-Ground", bg1Name: "12-Background1", bg2Name: "12-Background2")
    ]
    
    private let chapterDifficulty: [Int:Difficulty] = [
        1: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 3/10),
        2: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 3/10),
        3: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 3/10),
        4: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 3/10),
        5: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 4/10),
        6: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 4/10),
        7: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 4/10),
        8: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 5/10),
        9: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 5/10),
        10: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 5/10),
        11: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 5/10),
        12: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 5/10)
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
    
    func getDifficulty() -> Difficulty {
        return self.chapterDifficulty[self.chapterNo]!
    }
}
