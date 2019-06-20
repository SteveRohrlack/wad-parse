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
    
    // MARK: - convenience attributes
    
    var graphics: [WadGraphic] {
        return lumps.filter {
            $0.categories.contains(.graphic)
        }.map {
            $0.content(in: data) as? WadGraphic
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
    }
    
    var sprites: [WadGraphicSprite] {
        return lumps.filter {
            $0.categories.contains(.graphicSprite)
        }.map {
            $0.content(in: data) as? WadGraphicSprite
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
    }
    
    var flats: [WadGraphicFlat] {
        return lumps.filter {
            $0.categories.contains(.graphicFlat)
        }.map {
            $0.content(in: data) as? WadGraphicFlat
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
    }
    
    var sounds: [WadSound] {
        return lumps.filter {
            $0.categories.contains(.sound)
        }.map {
            $0.content(in: data) as? WadSound
        }.filter {
            $0 != nil
        }.map {
            $0!
        }
    }
    
    var palettes: WadPalettes? {
        return lumps(inCategory: .palette)?
            .first?
            .content(in: data) as? WadPalettes
    }
    
    var colormaps: WadColormaps? {
        return lumps(inCategory: .colormap)?
            .first?
            .content(in: data) as? WadColormaps
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
    
    // MARK: - specific lump content access
    
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
        let graphicName = name.uppercased()
        
        guard let lump: WadLumpGraphicSprite = lump(named: graphicName, in: .graphicSprite) else {
            return nil
        }
        
        return lump.content(in: data) as? WadGraphicSprite
    }
    
    func flat(named name: String) -> WadGraphicFlat? {
        let graphicName = name.uppercased()
        
        guard let lump: WadLumpGraphicFlat = lump(named: graphicName, in: .graphicFlat) else {
            return nil
        }
        
        return lump.content(in: data) as? WadGraphicFlat
    }
    
    // MARK: - generic lump content access

    func graphic(named name: String) -> WadGraphic? {
        let graphicName = name.uppercased()
        
        let lumpContent = lumps.first {
            $0.categories.contains(.graphic) && $0.name == graphicName
        }?.content(in: data)
        
        return lumpContent as? WadGraphic
    }
    
    func sound(named name: String) -> WadSound? {
        let soundName = name.uppercased()
        
        let lumpContent = lumps.first {
            $0.categories.contains(.sound) && $0.name == soundName
        }?.content(in: data)
        
        return lumpContent as? WadSound
    }
    
    // MARK: - generic lump access
    
    func lump(named name: String, in category: WadLumpCategory? = nil) -> WadLump? {
        let lumpName = name.uppercased()
        
        return lumps.first {
            if let category = category {
                return $0.name.uppercased() == lumpName && $0.categories.contains(category)
            }
            
            return $0.name.uppercased() == lumpName
        }
    }
    
    func lump<T: WadLump>(named name: String, in category: WadLumpCategory? = nil) -> T? {
        return lump(named: name, in: category) as? T
    }
    
    func lumps(inCategory category: WadLumpCategory) -> [WadLump]? {
        return lumps.filter {
            $0.categories.contains(category)
        }
    }
    
    func lumps(matching name: String) -> [WadLump] {
        let lumpName = name.uppercased()
        
        return lumps.filter {
            $0.name.uppercased().contains(lumpName)
        }
    }
    
}
