//
//  WadLevel.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 02.08.18.
//

import Foundation

struct WadLevel {
    
    let name: String
    let definitions: [WadLump]
    
    func including(part definition: WadLump) -> WadLevel {
        var newDefinitions = definitions
        newDefinitions.append(definition)
        
        return WadLevel(name: name, definitions: newDefinitions)
    }
    
}
