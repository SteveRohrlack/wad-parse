//
//  WadLumpGeneric.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//

import Foundation

struct WadLumpGeneric: WadLump {
    
    let offset: UInt32
    let size: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        return nil
    }
    
}
