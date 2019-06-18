//
//  WadLumpGraphicSprite.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 14.08.18.
//
//  see https://doomwiki.org/wiki/Sprite

import Foundation

struct WadLumpGraphicSprite: WadLump {
    
    enum Errors: Error {
        case frameDataNotReadable(String)
        case frameIndexOutOfBounds(Int)
        case frameRotationOutOfBounds(Int)
    }
    
    let offset: UInt32
    let size: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let picture = WadLumpGraphicPicture(
            offset: offset,
            size: size,
            name: name,
            categories: categories
        ).content(in: wadData) as! WadGraphicPicture
        
        let indexEndOfPrefix = name.index(name.startIndex, offsetBy: 4)
        
        guard let frameData = String(name[indexEndOfPrefix...]).data(using: String.Encoding.ascii) else {
            fatalError("frame data not readable in lump \(name)")
        }
        
        guard frameData.count >= 2, frameData.count <= 4, frameData.count != 3 else {
            fatalError("frame data invalid")
        }
        
        var frame: UInt8 = frameData.intValue(at: 0)
        
        guard frame >= 65 else {
            fatalError("frame index out of bounds: \(Int(frame) - 65)")
        }
        
        frame -= 65
        
        var rotation: UInt8 = frameData.intValue(at: 1)
        
        guard rotation >= 48 else {
            fatalError("frame rotation out of bounds: \(Int(rotation) - 48)")
        }
        
        rotation -= 48
        
        var mirrorFrame: UInt8?
        var mirrorRotation: UInt8?
        
        if frameData.count > 2 {
            mirrorFrame = frameData.intValue(at: 2)
            
            guard mirrorFrame! >= 65 else {
                fatalError("frame index out of bounds: \(Int(mirrorFrame!) - 65)")
            }
            
            mirrorFrame! -= 65
            
            mirrorRotation = frameData.intValue(at: 3)
            
            guard mirrorRotation! >= 48 else {
                fatalError("frame rotation out of bounds: \(Int(mirrorRotation!) - 48)")
            }
            
            mirrorRotation! -= 48
        }
        
        return WadGraphicSprite(
            picture: picture,
            index: frame,
            rotation: rotation,
            mirrorIndex: mirrorFrame,
            mirrorRotation: mirrorRotation
        )
    }

}
