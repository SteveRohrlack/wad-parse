//
//  WadSprite.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 13.08.18.
//
//  see https://doomwiki.org/wiki/Sprite

import Foundation

struct WadGraphicSprite: WadGraphic, WadLumpContent {
    
    let name: String
    let width: UInt16
    let height: UInt16
    let offsetLeft: Int16
    let offsetTop: Int16
    let pixels: WadPixels
    
    let index: UInt8
    let rotation: UInt8
    let mirrorIndex: UInt8?
    let mirrorRotation: UInt8?
    
    init(picture: WadGraphicPicture, index: UInt8, rotation: UInt8, mirrorIndex: UInt8?, mirrorRotation: UInt8?) {
        self.init(
            name: picture.name,
            width: picture.width,
            height: picture.height,
            offsetLeft: picture.offsetLeft,
            offsetTop: picture.offsetTop,
            pixels: picture.pixels,
            index: index,
            rotation: rotation,
            mirrorIndex: mirrorIndex,
            mirrorRotation: mirrorRotation
        )
    }
    
    init(name: String, width: UInt16, height: UInt16, offsetLeft: Int16, offsetTop: Int16, pixels: WadPixels, index: UInt8, rotation: UInt8, mirrorIndex: UInt8?, mirrorRotation: UInt8?) {
        self.name = name
        self.height = height
        self.width = width
        self.offsetLeft = offsetLeft
        self.offsetTop = offsetTop
        self.pixels = pixels
        
        self.index = index
        self.rotation = rotation
        self.mirrorIndex = mirrorIndex
        self.mirrorRotation = mirrorRotation
    }
    
}
