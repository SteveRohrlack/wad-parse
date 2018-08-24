//
//  WadSpriteGroup.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 20.08.18.
//

import Foundation

struct WadSpriteGroup {
    
    let name: String
    let frames: [WadGraphicSprite]

    let enclosingFrame: CGRect
    
    init(name: String, frames: [WadGraphicSprite]) {
        self.frames = frames.sorted { (a, b) in
            a.index < b.index
        }
        
        if name.count > 4 {
            let indexEndOfPrefix = name.index(name.startIndex, offsetBy: 4)
            self.name = String(name[..<indexEndOfPrefix])
        } else {
            self.name = name
        }
        
        guard frames.count > 0 else {
            self.enclosingFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        
        var y0max = Int.min
        var y1min = Int.max
        
        var x0min = Int.max
        var x1max = Int.min
        
        for frame in frames {
            let y0 = Int(frame.offsetTop)
            let y1 = (Int(frame.height) - y0) * -1
            
            let x0 = Int(frame.offsetLeft) * -1
            let x1 = Int(frame.width) + x0
            
            // y
            
            if y0 > y0max {
                y0max = y0
            }
            
            if y1 < y1min {
                y1min = y1
            }
            
            // x
            
            if x0 < x0min {
                x0min = x0
            }
            
            if x1 > x1max {
                x1max = x1
            }
        }
        
        let width = x1max - x0min
        let height = y0max - y1min
        let originX = x0min
        let originY = y1min
        
        self.enclosingFrame = CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    func groupFor(rotation: UInt8) -> WadSpriteGroup? {
        let groupFrames: [WadGraphicSprite] = frames.filter {
            $0.rotation == rotation
        }
        
        guard groupFrames.count > 0 else {
            return nil
        }
        
        return WadSpriteGroup(
            name: name,
            frames: groupFrames
        )
    }
}
