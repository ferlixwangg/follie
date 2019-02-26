//
//  chapter2.swift
//  cubeRun
//
//  Created by Steven Muliamin on 25/02/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

class chapter2 {
    init() {}
    
    let beats: [Beat] = [
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 2, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 2, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 1, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 1, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        
        Beat(nthLine: 2, nextBeatIn: 4, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 3, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 4, connectToNext: true),
        
        Beat(nthLine: 1, nextBeatIn: 3, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 4, connectToNext: true),
        
        Beat(nthLine: 5, nextBeatIn: 4, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 1, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 6/4, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 5, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 4, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 4, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 4, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 4, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 4, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 5, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: true),
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
        Beat(nthLine: 3, nextBeatIn: 1, connectToNext: false),
        Beat(nthLine: 2, nextBeatIn: 1, connectToNext: false),
        
        Beat(nthLine: 3, nextBeatIn: 4, connectToNext: true),
        
        Beat(nthLine: 3, nextBeatIn: 2, connectToNext: false),
    ]
}
