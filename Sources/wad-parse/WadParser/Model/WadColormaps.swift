//
//  WadColormaps.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 08.08.18.
//

import Foundation

struct WadColormaps: WadLumpContent {
    
    let maps: [WadColormap]
    
    func brightness(level: Int) -> WadColormap? {
        return maps.first {
            return $0.categories.contains { (category) in
                category == WadColormap.Category.brightness(level)
            }
        }
    }
    
}
