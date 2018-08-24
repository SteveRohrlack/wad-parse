//
//  WadPalette.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 06.08.18.
//
//  see https://doomwiki.org/wiki/PLAYPAL

import Foundation

struct WadPalette {
    
    enum Category {
        case normal
        case playerHurt(Int)
        case itemPickup(Int)
        case toolActive
        
        static func ==(lhs: Category, rhs: Category) -> Bool {
            switch (lhs, rhs) {
            case (.normal, .normal):
                return true
                
            case (.toolActive, .toolActive):
                return true
                
            case (let .playerHurt(level1), let .playerHurt(level2)):
                return level1 == level2
                
            case (let .itemPickup(level1), let .itemPickup(level2)):
                return level1 == level2
                
            default:
                return false
            }
        }
    }
    
    let category: Category?
    let colorComponents: [RGBA]
    
    init(colorComponents: [RGBA], index: Int) {
        var category: Category?
        
        switch index {
        case 0:
            category = .normal
        case 2,3,4,5,6,7,8:
            category = .playerHurt(index - 2)
        case 10,11,12:
            category = .itemPickup(index - 10)
        case 13:
            category = .toolActive
        default:
            category = nil
        }
        
        self.init(colors: colorComponents, category: category)
    }
    
    init(colors: [RGBA], category: Category?) {
        self.colorComponents = colors
        self.category = category
    }
    
}
