//
//  WadLumpParser.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 02.08.18.
//

import Foundation

struct WadLumpParser {
    
    enum Errors: Error {
        case invalidName
        case straySubsectionStart(String)
        case straySubsectionEnd(String)
        case invalidStructure(String)
    }
    
    static let lengthInBytes = 16
    static let lumpFileOffsetStartAddress = 0
    static let lumpSizeStartAddress = 4
    static let nameStartAddress = 8
    static let nameLengthInBytes = 8
    
    let wadHeader: WadHeader
    let wadData: Data
    
    func parse() throws -> [WadLump] {
        var lumps: [WadLump] = []
        
        var subsectionPath: [WadLumpCategory] = []
        
        for lumpIndex in 0..<Int(wadHeader.numberOfLumps) {
            
            let lump = try parseOne(at: lumpIndex, in: subsectionPath)
            
            // check if this dir is a subsection start/end marker
            
            for category in lump.categories {
                if case .subsectionStart = category {
                    subsectionPath.append(category)
                    break
                }
                
                if case .subsectionEnd(let sectionEndName) = category {
                    guard let lastSubsectionPathEntry = subsectionPath.last else {
                        // found subsection end marker although no start markers have been found yet
                        throw Errors.straySubsectionEnd(sectionEndName)
                    }
                    
                    guard case .subsectionStart(let sectionStartName) = lastSubsectionPathEntry, sectionStartName == sectionEndName else {
                        throw Errors.invalidStructure("subsection end marker \(sectionEndName) mismatch")
                    }
                    
                    // todo: check if last "subsection start" name equals name of "subsection end"
                    
                    subsectionPath.removeLast()
                    break
                }
            }
            
            lumps.append(lump)
        }
        
        // subsection path still contains an element but should be empty
        
        guard subsectionPath.isEmpty else {
            if case let .subsectionStart(name) = subsectionPath.last! {
                throw Errors.straySubsectionStart(name)
            }
            
            if case let .subsectionEnd(name) = subsectionPath.last! {
                throw Errors.straySubsectionEnd(name)
            }
            
            throw Errors.invalidStructure("")
        }
        
        return lumps
    }
    
    private func parseOne(at lumpIndex: Int, in subsections: [WadLumpCategory]) throws -> WadLump {
        
        // get lump data
        
        let relativeLumpStartAddress = lumpIndex * WadLumpParser.lengthInBytes
        let relativeLumpEndAddress = (lumpIndex + 1) * WadLumpParser.lengthInBytes
        
        let lumpAddress: Range<Int> = (Int(wadHeader.directoryOffset) + relativeLumpStartAddress)..<(Int(wadHeader.directoryOffset) + relativeLumpEndAddress)
        let lumpData = wadData.subdata(in: lumpAddress)
    
        // get lump details
        
        guard let name = lumpData.stringValue(at: WadLumpParser.nameStartAddress, length: WadLumpParser.nameLengthInBytes, encoding: .ascii) else {
            throw Errors.invalidName
        }
        
        let cleanedName = name.replacingOccurrences(of: "\0", with: "")
        
        let lumpFileOffset: UInt32 = lumpData.intValue(at: WadLumpParser.lumpFileOffsetStartAddress)
        let lumpSize: UInt32 = lumpData.intValue(at: WadLumpParser.lumpSizeStartAddress)
        
        // map category to lump type
        
        let categories = WadLumpCategory.categorize(lumpName: cleanedName, sized: lumpSize, in: subsections)
        
        // factory WadLump type
        
        switch categories {
        case let c where c.contains(WadLumpCategory.exitText):
            return WadLumpColoredText(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.graphicSprite):
            return WadLumpGraphicSprite(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.graphicPicture):
            return WadLumpGraphicPicture(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.graphicFlat):
            return WadLumpGraphicFlat(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.palette):
            return WadLumpPalettes(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.colormap):
            return WadLumpColormap(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        case let c where c.contains(WadLumpCategory.pcSpeakerSound):
            return WadLumpSoundSpeaker(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        default:
            return WadLumpGeneric(offset: lumpFileOffset, size: lumpSize, name: cleanedName, categories: categories)
        }
    }
    
}
