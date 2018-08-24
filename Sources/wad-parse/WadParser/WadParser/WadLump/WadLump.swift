//
//  WadLump.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//

import Foundation

protocol WadLump {
    
    var lumpOffset: UInt32 { get }
    var lumpSize: UInt32 { get }
    var name: String { get }
    var categories: Set<WadLumpCategory> { get }
    
    init(lumpOffset: UInt32, lumpSize: UInt32, name: String, categories: Set<WadLumpCategory>)
    
    func readData(in wadData: Data) -> Data
    func content(in wadData: Data) -> WadLumpContent?
    func including(categories: Set<WadLumpCategory>) -> WadLump
    
}

extension WadLump {
    
    func readData(in wadData: Data) -> Data {
        let lumpAddress: Range<Int> = Int(lumpOffset)..<(Int(lumpOffset) + Int(lumpSize))
        return wadData.subdata(in: lumpAddress)
    }
    
    func including(categories newCategories: Set<WadLumpCategory>) -> WadLump {
        return Self.init(lumpOffset: lumpOffset, lumpSize: lumpSize, name: name, categories: categories.union(newCategories))
    }
    
}
