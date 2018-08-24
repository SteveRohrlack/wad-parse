//
//  WadLumpCategory.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//

import Foundation

enum WadLumpCategory: Hashable {
    
    typealias Category = WadLumpCategory
    
    // static category names
    case palette
    case colormap
    case exitText
    case wallPatchIndex
    case midiMapping
    case gravisUltrasoundMapping
    
    // dynamic category names
    case wallTexture
    case demo
    case sound
    case pcSpeakerSound
    case soundcardSound
    case song
    
    // map markers
    // dynamic category names
    case map
    case mapByNumber
    case mapByName
    
    // maps parts
    case mapPart
    case mapThings
    case mapLineDefinitions
    case mapSideDefinitions
    case mapVertextes
    case mapSegments
    case mapSubSectors
    case mapNodes
    case mapSectors
    case mapReject
    case mapBlockmap
    
    // graphics
    case graphic
    case graphicFlat
    case graphicPicture
    case graphicSprite

    // general marker
    case marker
    
    // general subsections
    case subsectionStart(String)
    case subsectionEnd(String)
    
    static let subsectionStartSuffix = "_START"
    static let subsectionEndSuffix = "_END"
    
    static let subsectionFlat = "F"
    static let subsectionSprite = "S"
    
    static func categorize(lumpName: String, sized lumpSize: UInt32, in subsections: [Category]) -> Set<Category> {
        let categoryName = lumpName.uppercased()
        
        var categories: Set<Category> = []
        
        switch categoryName {
            
        // once per wad
        case "PLAYPAL":
            categories.insert(.palette)
        case "COLORMAP":
            categories.insert(.colormap)
        case "ENDOOM":
            categories.insert(.exitText)
        case "PNAMES":
            categories.insert(.wallPatchIndex)
        case "GENMIDI":
            categories.insert(.midiMapping)
        case "DMXGUS":
            categories.insert(.gravisUltrasoundMapping)

        // map parts, once per map
        case "THINGS":
            categories.insert(.mapPart)
            categories.insert(.mapThings)
        case "LINEDEFS":
            categories.insert(.mapPart)
            categories.insert(.mapLineDefinitions)
        case "SIDEDEFS":
            categories.insert(.mapPart)
            categories.insert(.mapSideDefinitions)
        case "VERTEXES":
            categories.insert(.mapPart)
            categories.insert(.mapVertextes)
        case "SEGS":
            categories.insert(.mapPart)
            categories.insert(.mapSegments)
        case "SSECTORS":
            categories.insert(.mapPart)
            categories.insert(.mapSubSectors)
        case "NODES":
            categories.insert(.mapPart)
            categories.insert(.mapNodes)
        case "SECTORS":
            categories.insert(.mapPart)
            categories.insert(.mapSectors)
        case "REJECT":
            categories.insert(.mapPart)
            categories.insert(.mapReject)
        case "BLOCKMAP":
            categories.insert(.mapPart)
            categories.insert(.mapBlockmap)
            
        // dynamically named dirs
            
        case let n where n.matches(regex: "^DEMO[0-9]{1,4}$"):
            categories.insert(.demo)
        case let n where n.matches(regex: "^TEXTURE[0-9]$"):
            categories.insert(.graphic)
            categories.insert(.wallTexture)
        case let n where n.matches(regex: "^DP.*$"):
            categories.insert(.sound)
            categories.insert(.pcSpeakerSound)
        case let n where n.matches(regex: "^DS.*$"):
            categories.insert(.sound)
            categories.insert(.soundcardSound)
        case let n where n.matches(regex: "^D_.*$"):
            categories.insert(.sound)
            categories.insert(.song)
        case let n where n.matches(regex: "^MAP[0-9]{1,5}$"):
            categories.insert(.map)
            categories.insert(.mapByNumber)
        case let n where n.matches(regex: "^E[1-9]{1,3}M[1-9]{1,3}$"):
            categories.insert(.map)
            categories.insert(.mapByName)
        default:
            break
        }
        
        if !categories.isEmpty {
            return categories
        }
        
        // everything else
        
        // markers (have no size)
        
        if lumpSize == 0 {
            categories = [.marker]
            
            // start and end of subsection
            
            if categoryName.hasSuffix(Category.subsectionStartSuffix) {
                let subsectionName = categoryName.replacingOccurrences(of: Category.Category.subsectionStartSuffix, with: "")
                
                categories.insert(.subsectionStart(subsectionName))
            }
            
            if categoryName.hasSuffix(Category.subsectionEndSuffix) {
                let subsectionName = categoryName.replacingOccurrences(of: Category.Category.subsectionEndSuffix, with: "")
                
                categories.insert(.subsectionEnd(subsectionName))
            }
            
            return categories
        }
        
        // categories relying on the current subsection path
        
        for subsection in subsections {
            if case let .subsectionStart(name) = subsection {
                switch name {
                case Category.subsectionFlat:
                    categories.insert(.graphic)
                    categories.insert(.graphicFlat)
                case Category.subsectionSprite:
                    categories.insert(.graphic)
                    categories.insert(.graphicPicture)
                    categories.insert(.graphicSprite)
                default:
                    continue
                }
            }
        }
        
        if !categories.isEmpty {
            return categories
        }
        
        // everything else is a graphic in "picture" format
        
        return [.graphic, .graphicPicture]
    }
    
}
