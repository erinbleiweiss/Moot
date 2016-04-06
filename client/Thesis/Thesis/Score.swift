//
//  Score.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation

class Score{
    
    var name: String
    var score: Int
    var uuid: String
    
    init(name: String, score: Int, uuid: String) {
        self.name = name
        self.score = score
        self.uuid = uuid
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getScore() -> Int{
        return self.score
    }
    
    func isCurrentUser() -> Bool {
        return self.uuid == get_uuid()
    }
    
}