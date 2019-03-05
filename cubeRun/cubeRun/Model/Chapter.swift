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
        1: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 2/10),
        2: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 2/10),
        3: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 2/10),
        4: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 2/10),
        5: Difficulty(maxInterval: 1, maxHoldNum: 1, maxHoldBeat: 2, holdChance: 3/10),
        6: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 3/10),
        7: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 3/10),
        8: Difficulty(maxInterval: 1, maxHoldNum: 2, maxHoldBeat: 2, holdChance: 3/10),
        9: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 4/10),
        10: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 4/10),
        11: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 4/10),
        12: Difficulty(maxInterval: 1, maxHoldNum: 3, maxHoldBeat: 2, holdChance: 4/10)
    ]
    
    private let chapterAurora: [Int:Aurora] = [
        1: Aurora(colors: [
            UIColor.init(red: 0.3, green: 0, blue: 1, alpha: 1),
            UIColor.init(red: 0, green: 1, blue: 1, alpha: 1),
            UIColor.init(red: 0.2, green: 1, blue: 0.2, alpha: 1)
            ]),
        2: Aurora(colors: [
            UIColor.init(red: 198/255, green: 240/255, blue: 92/255, alpha: 1),
            UIColor.init(red: 78/255, green: 181/255, blue: 111/255, alpha: 1)
            ]),
        3: Aurora(colors: [
            UIColor.init(red: 88/255, green: 230/255, blue: 209/255, alpha: 1),
            UIColor.init(red: 187/255, green: 100/255, blue: 117/255, alpha: 1)
            ]),
        4: Aurora(colors: [
            UIColor.init(red: 255/255, green: 209/255, blue: 102211/255, alpha: 1),
            UIColor.init(red: 248/255, green: 117/255, blue: 9255, alpha: 1),
            UIColor.init(red: 228/255, green: 128/255, blue: 70/255, alpha: 1)
            ]),
        5: Aurora(colors: [
            UIColor.init(red: 135/255, green: 227/255, blue: 229/255, alpha: 1),
            UIColor.init(red: 1/255, green: 152/255, blue: 151/255, alpha: 1),
            UIColor.init(red: 160/255, green: 214/255, blue: 204/255, alpha: 1)
            ]),
        6: Aurora(colors: [
            UIColor.init(red: 0.3, green: 0, blue: 1, alpha: 1),
            UIColor.init(red: 0, green: 1, blue: 1, alpha: 1),
            UIColor.init(red: 0.2, green: 1, blue: 0.2, alpha: 1)
            ]),
        7: Aurora(colors: [
            UIColor.init(red: 135/255, green: 0/255, blue: 191/255, alpha: 1),
            UIColor.init(red: 183/255, green: 111/255, blue: 15/255, alpha: 1)
            ]),
        8: Aurora(colors: [
            UIColor.init(red: 112/255, green: 198/255, blue: 171/255, alpha: 1),
            UIColor.init(red: 0/255, green: 111/255, blue: 218/255, alpha: 1)
            ]),
        9: Aurora(colors: [
            UIColor.init(red: 4/255, green: 49/255, blue: 90/255, alpha: 1),
            UIColor.init(red: 57/255, green: 152/255, blue: 158/255, alpha: 1),
            UIColor.init(red: 129/255, green: 202/255, blue: 190/255, alpha: 1)
            ]),
        10: Aurora(colors: [
            UIColor.init(red: 209/255, green: 124/255, blue: 112/255, alpha: 1),
            UIColor.init(red: 0, green: 1, blue: 1, alpha: 1),
            ]),
        11: Aurora(colors: [
            UIColor.init(red: 153/255, green: 108/255, blue: 188/255, alpha: 1),
            UIColor.init(red: 105/255, green: 104/255, blue: 218/255, alpha: 1),
            UIColor.init(red: 203/255, green: 165/255, blue: 129/255, alpha: 1)
            ]),
        12: Aurora(colors: [
            UIColor.init(red: 0, green: 1, blue: 1, alpha: 1),
            UIColor.init(red: 0.2, green: 1, blue: 0.2, alpha: 1)
            ])
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
    
    func getAurora() -> Aurora {
        return self.chapterAurora[self.chapterNo]!
    }
}
