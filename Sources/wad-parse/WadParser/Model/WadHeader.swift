//
//  WadHeader.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 02.08.18.
//

import Foundation

struct WadHeader {
    
    let wadType: WadType
    let numberOfLumps: Int32
    let directoryOffset: Int32
    
}
