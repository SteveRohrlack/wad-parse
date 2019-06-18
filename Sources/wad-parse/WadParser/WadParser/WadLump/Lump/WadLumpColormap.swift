//
//  WadLumpColormap.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 08.08.18.
//
//  see https://doomwiki.org/wiki/COLORMAP
//  see https://zdoom.org/wiki/COLORMAP

import Foundation

struct WadLumpColormap: WadLump {
    
    typealias const = WadLumpColormap
    
    typealias LumpContentType = [WadPalette]
    
    static let numberOfMaps = 34
    static let mapSizeInBytes = 256
    
    let offset: UInt32
    let size: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        let maps: [WadColormap] = (0..<const.numberOfMaps).map { (mapIndex) in
            let values: [UInt8] = (0..<const.mapSizeInBytes).map { (relativeValueAddress) in
                let valueAddress = mapIndex * const.mapSizeInBytes + relativeValueAddress
                return lumpData.intValue(at: valueAddress)
            }
            
            return WadColormap(index: mapIndex, values: values)
        }
        
        return WadColormaps(maps: maps) as WadLumpContent
    }
    
}
