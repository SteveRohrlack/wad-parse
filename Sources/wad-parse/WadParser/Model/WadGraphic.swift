//
//  WadGraphic.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 20.08.18.
//

import Foundation

protocol WadGraphic: WadLumpContent {
    
    var name: String { get }
    var width: UInt16 { get }
    var height: UInt16 { get }
    var offsetLeft: Int16 { get }
    var offsetTop: Int16 { get }
    var pixels: WadPixels { get }
}
