//
//  WadGraphicFlat.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 22.08.18.
//

import Foundation

struct WadGraphicFlat: WadGraphic, WadLumpContent {
    
    static let height = 64
    static let width = 64
    
    let name: String
    let width: UInt16
    let height: UInt16
    let offsetLeft: Int16
    let offsetTop: Int16
    let pixels: WadPixels
    
    init(name: String, pixels: WadPixels) {
        self.name = name
        self.pixels = pixels
        
        self.width = UInt16(WadGraphicFlat.width)
        self.height = UInt16(WadGraphicFlat.height)
        self.offsetTop = 0
        self.offsetLeft = 0
    }
    
}
