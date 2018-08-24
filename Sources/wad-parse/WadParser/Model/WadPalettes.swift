//
//  WadPalettes.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 07.08.18.
//
//  see https://doomwiki.org/wiki/PLAYPAL

import Foundation

struct WadPalettes: WadLumpContent {

    let palettes: [WadPalette]
    
    var `default`: WadPalette? {
        return palettes.first {
            guard let paletteCategory = $0.category else {
                return false
            }
            
            return paletteCategory == .normal
        }
    }
    
    func `in`(category: WadPalette.Category) -> WadPalette? {
        return palettes.first {
            guard let paletteCategory = $0.category else {
                return false
            }
            
            return paletteCategory == category
        }
    }
    
}
