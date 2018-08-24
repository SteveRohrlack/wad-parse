//
//  WadLumpGraphicFlat.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 22.08.18.
//

import Foundation

struct WadLumpGraphicFlat: WadLump {
    
    let lumpOffset: UInt32
    let lumpSize: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        var pixels = WadPixels(columns: WadGraphicFlat.width, rows: WadGraphicFlat.height)
        
        for rowIndex in (0..<WadGraphicFlat.height) {
            for colIndex in (0..<WadGraphicFlat.width) {
                let pixelIndex = colIndex + (rowIndex * WadGraphicFlat.height)
                
                let pixelValue: UInt8 = lumpData.intValue(at: pixelIndex)
                
                pixels[colIndex, rowIndex] = pixelValue
            }
        }
        
        return WadGraphicFlat(name: name, pixels: pixels)
    }
    
}
