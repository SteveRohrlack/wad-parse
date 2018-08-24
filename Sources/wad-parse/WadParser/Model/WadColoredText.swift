//
//  ColoredText.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//
// see https://doomwiki.org/wiki/ENDOOM

import Foundation

struct WadColoredText: WadLumpContent {
    
    struct Color {
        
        enum Errors: Error {
            case invalidColorValue(UInt8)
        }
        
        enum Background {
            case black
            case blue
            case green
            case cyan
            case red
            case magenta
            case brown
            case gray
        }
        
        enum Foreground {
            case darkGrey
            case lightBlue
            case lightGreen
            case lightCyan
            case lightRed
            case lightMagenta
            case lightYellow
            case lightWhite
        }
        
        let foreground: Foreground
        let background: Background
        let blink: Bool
        
        static func from(byte: UInt8) throws -> Color {
            let blink = Int(byte >> 7) == 1
            
            let foregroundColorValue = UInt8(byte & 0x0F)
            let backgrountColorValue = UInt8((byte << 1) >> 5)
            
            var foregroundColor: Foreground
            var backgroundColor: Background
            
            switch backgrountColorValue {
            case 0:
                backgroundColor = .black
            case 1:
                backgroundColor = .blue
            case 2:
                backgroundColor = .green
            case 3:
                backgroundColor = .cyan
            case 4:
                backgroundColor = .red
            case 5:
                backgroundColor = .magenta
            case 6:
                backgroundColor = .brown
            case 7:
                backgroundColor = .gray
            default:
                throw Errors.invalidColorValue(backgrountColorValue)
            }
            
            switch foregroundColorValue {
            case 0,1:
                foregroundColor = .darkGrey
            case 2,3:
                foregroundColor = .lightBlue
            case 4,5:
                foregroundColor = .lightGreen
            case 6,7:
                foregroundColor = .lightCyan
            case 8,9:
                foregroundColor = .lightRed
            case 10,11:
                foregroundColor = .lightMagenta
            case 12,13:
                foregroundColor = .lightYellow
            case 14,15:
                foregroundColor = .lightWhite
            default:
                throw Errors.invalidColorValue(foregroundColorValue)
            }
            
            return Color(foreground: foregroundColor, background: backgroundColor, blink: blink)
        }
    }
    
    struct ColoredCharacter {
        let character: Character
        let color: Color
    }
    
    let characters: [ColoredCharacter]
    
    var plain: String  {
        return characters.reduce("") { (carry: String, coloredCharacter: ColoredCharacter) in
            return String("\(carry)\(coloredCharacter.character)")
        }
    }
    
}
