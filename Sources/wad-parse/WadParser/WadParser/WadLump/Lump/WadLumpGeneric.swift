//
//  WadLumpGeneric.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 03.08.18.
//

import Foundation

struct WadLumpGeneric: WadLump {
    
    let lumpOffset: UInt32
    let lumpSize: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        return nil
    }
    
}
