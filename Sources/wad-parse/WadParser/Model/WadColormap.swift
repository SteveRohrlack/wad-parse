//
//  WadColormap.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 08.08.18.
//

import Foundation

struct WadColormap {
    
    private static let categoryIndexBrightnessStart = 0
    private static let categoryIndexBrightnessEnd = 31
    
    private static let categoryIndexPartialInvisibility = 6
    private static let categoryIndexSpecial = 32
    
    enum Category {
        case brightness(Int)
        case partialInvisibility
        case special
        
        static func ==(lhs: Category, rhs: Category) -> Bool {
            switch (lhs, rhs) {
            case (.partialInvisibility, .partialInvisibility):
                return true
                
            case (.special, .special):
                return true
                
            case (let .brightness(level1), let .brightness(level2)):
                return level1 == level2
                
            default:
                return false
            }
        }
    }
    
    let values: [UInt8]
    let categories: [Category]
    
    init(index: Int, values: [UInt8]) {
        self.values = values
        
        var categories: [Category] = []
        
        switch index {
        case WadColormap.categoryIndexBrightnessStart...WadColormap.categoryIndexBrightnessEnd:
            categories.append(.brightness(index))
        default:
            break
        }
        
        if index == WadColormap.categoryIndexPartialInvisibility {
            categories.append(.partialInvisibility)
        }
        
        if index == WadColormap.categoryIndexSpecial {
            categories.append(.special)
        }
        
        self.categories = categories
    }
    
}
