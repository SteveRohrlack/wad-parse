//
//  WadLumpColoredText.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//

import Foundation

struct WadLumpColoredText: WadLump {
    
    let offset: UInt32
    let size: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        var coloredCharacters: [WadColoredText.ColoredCharacter] = []
        
        for characterIndex in stride(from: 0, to: Int(size), by: 2) {
            
            // characters originating from non-standard ascii can not be decoded
            // this is the default value for such characters
            var character = Character("-")
            
            if let decodedChar = lumpData.stringValue(at: characterIndex, length: 1, encoding: .nonLossyASCII) {
                character = decodedChar.first!
            }
            
            let colorByte: UInt8 = lumpData.intValue(at: characterIndex + 1)
            
            guard let color = try? WadColoredText.Color.from(byte: colorByte) else {
                continue
            }
            
            coloredCharacters.append(
                WadColoredText.ColoredCharacter(
                    character: character,
                    color: color
                )
            )
        }
        
        return WadColoredText(characters: coloredCharacters) as WadLumpContent
    }
    
}
