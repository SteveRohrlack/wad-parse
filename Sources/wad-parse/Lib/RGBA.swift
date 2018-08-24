//
//  RGBColor.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 07.08.18.
//

import Foundation

struct RGBA {
    
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: UInt8
    
    var argbColor: UInt32 {
        return Data(bytes: [alpha, red, green, blue]).intValue(at: 0)
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = UInt8.max) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

}
