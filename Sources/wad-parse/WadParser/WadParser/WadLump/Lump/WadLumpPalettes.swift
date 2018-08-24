//
//  WadLumpPalettes.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 06.08.18.
//
//  see https://doomwiki.org/wiki/PLAYPAL

import Foundation

struct WadLumpPalettes: WadLump {
    
    typealias LumpContentType = [WadPalette]
    
    static let numberOfPalettes = 14
    static let paletteLengthInBytes = 768
    static let numberOfColorsOnPalette = 256
    static let colorLengthInBytes = 3 // rgb
    
    let lumpOffset: UInt32
    let lumpSize: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        let palettes: [WadPalette] = (0..<WadLumpPalettes.numberOfPalettes).map { (paletteIndex) in
            let paletteAddress: Range<Int> = (paletteIndex * WadLumpPalettes.paletteLengthInBytes)..<((paletteIndex + 1) * WadLumpPalettes.paletteLengthInBytes)
            let paletteData = lumpData.subdata(in: paletteAddress)
            
            let colorComponents: [RGBA] = (0..<WadLumpPalettes.numberOfColorsOnPalette).map { (colorIndex) in
                let colorAddress: Range<Int> = (colorIndex * WadLumpPalettes.colorLengthInBytes)..<((colorIndex + 1) * WadLumpPalettes.colorLengthInBytes)
                let colorData = paletteData.subdata(in: colorAddress)
                
                let redComponent: UInt8 = colorData.intValue(at: 0)
                let greenComponent: UInt8 = colorData.intValue(at: 1)
                let blueComponent: UInt8 = colorData.intValue(at: 2)
                
                return RGBA(red: redComponent, green: greenComponent, blue: blueComponent)
            }

            return WadPalette(colorComponents: colorComponents, index: paletteIndex)
        }

        return WadPalettes(palettes: palettes) as WadLumpContent
    }
    
}
