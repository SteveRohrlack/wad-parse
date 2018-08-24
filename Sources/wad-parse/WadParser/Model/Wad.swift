//
//  WadModel.swift
//  Rainbow
//
//  Created by Steve Rohrlack on 02.08.18.
//

import Foundation

struct Wad {
    
    let filename: String
    let header: WadHeader
    let lumps: [WadLump]
    let data: Data
    
    var graphics: [WadGraphic] {
        return lumps.filter {
            $0.categories.contains(.graphic) && $0 is WadLumpGraphicPicture
        }.map {
            $0.content(in: data) as? WadGraphic
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
    }
    
    var sprites: [WadGraphicSprite] {
        let sprites = lumps.filter {
            $0.categories.contains(.graphicSprite)
        }.map {
            $0.content(in: data) as? WadGraphicSprite
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
        
        return sprites
    }
    
    var palettes: WadPalettes? {
        guard let lumps = lumpsIn(category: .palette) else {
            return nil
        }
        
        return lumps.first?.content(in: data) as? WadPalettes
    }
    
    var colormaps: WadColormaps? {
        guard let lumps = lumpsIn(category: .colormap) else {
            return nil
        }
        
        return lumps.first?.content(in: data) as? WadColormaps
    }
    
    var levels: [WadLevel] {
        var levels: [WadLevel] = []
        
        var level: WadLevel?
        
        for lump in lumps {
            switch lump.categories {
            case let c where c.contains(.map):
                if level != nil {
                    levels.append(level!)
                }
                
                level = WadLevel(name: lump.name, definitions: [])
            case let c where c.contains(.mapPart):
                level = level?.including(part: lump)
            default:
                if level != nil {
                    levels.append(level!)
                    level = nil
                }
            }
        }
        
        return levels
    }
    
    func lump<T: WadLump>(named name: String, in lumpCategory: WadLumpCategory? = nil) -> T? {
        let lumpName = name.uppercased()
        
        return lumps.first {
            if let category = lumpCategory {
                return $0.name == lumpName && $0.categories.contains(category)
            }
            
            return $0.name == lumpName
        } as? T
    }
    
    func lumpsIn(category: WadLumpCategory) -> [WadLump]? {
        return lumps.filter {
            return $0.categories.contains(category)
        }
    }
    
    func spriteGroup(named name: String) -> WadSpriteGroup? {
        let spriteName = name.uppercased()
        
        let frames = lumps.filter {
            $0.categories.contains(.graphicSprite) && $0.name.hasPrefix(spriteName)
        }.map {
            $0.content(in: data) as? WadGraphicSprite
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
        
        guard frames.count > 0 else {
            return nil
        }
        
        return WadSpriteGroup(name: frames[0].name, frames: frames)
    }
    
    func sprite(named name: String) -> WadGraphicSprite? {
        guard let lump: WadLumpGraphicSprite = lump(named: name, in: .graphicSprite) else {
            return nil
        }
        
        return lump.content(in: data) as? WadGraphicSprite
    }

    func graphic(named name: String) -> WadGraphic? {
        let graphicName = name.uppercased()
        
        let lumpContent = lumps.first {
            $0.categories.contains(.graphic) && $0.name == graphicName
        }?.content(in: data)
        
        return lumpContent as? WadGraphic
    }
    
}
