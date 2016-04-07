//
//  Raleway.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/7/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

private let familyName = "Raleway"

enum Raleway: String {
    
    case Black = "Black"
    case Bold = "Bold"
    case ExtraBold = "ExtraBold"
    case ExtraLight = "ExtraLight"
    case Light = "Light"
    case Medium = "Medium"
    case Regular = "Regular"
    case SemiBold = "SemiBold"
    case Thin = "Thin"
    
    func withSize(size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size){
            return font
        }
        fatalError("Font \(fullFontName) does not exist")
    }
    
    private var fullFontName: String {
        
        var fullFontName: String
        if rawValue.isEmpty {
            fullFontName = familyName + "-Regular"
        } else {
            fullFontName = familyName + "-" + rawValue
        }
        return fullFontName
    }
    
    
}