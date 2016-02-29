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
    
    init (name: String, description: String){
        self.name = name
        self.description = description
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getDescription() -> String{
        return self.description
    }
    
    
}