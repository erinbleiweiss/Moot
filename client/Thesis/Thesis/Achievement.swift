//
//  Achievement.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/29/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation


struct Achievement{
    
    private var name: String
    private var description: String
    private var earned: Bool
    private var visible: Bool
    
    init (name: String, description: String, earned: Bool, visible: Bool){
        self.name = name
        self.description = description
        self.earned = earned
        self.visible = visible
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getDescription() -> String{
        return self.description
    }
    
    func isEarned() -> Bool{
        return self.earned
    }
    
    func isVisible() -> Bool{
        return self.visible
    }
    
    
}