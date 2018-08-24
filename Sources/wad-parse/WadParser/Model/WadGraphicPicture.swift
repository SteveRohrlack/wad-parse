//
//  WadGraphicPicture.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 06.08.18.
//

import Foundation

struct WadGraphicPicture: WadGraphic, WadLumpContent {
    
    let name: String
    let width: UInt16
    let height: UInt16
    let offsetLeft: Int16
    let offsetTop: Int16
    let pixels: WadPixels
    
    let isPositionAbsolute: Bool
    
    init(name: String, width: UInt16, height: UInt16, offsetLeft: Int16, offsetTop: Int16, pixels: WadPixels) {
        self.name = name
        self.height = height
        self.width = width
        self.offsetLeft = offsetLeft
        self.offsetTop = offsetTop
        self.pixels = pixels
        
        self.isPositionAbsolute = (offsetTop < 0 && offsetLeft < 0)
    }
    
}
