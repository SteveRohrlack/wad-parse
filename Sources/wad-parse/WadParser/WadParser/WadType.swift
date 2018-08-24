//
//  WadType.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 02.08.18.
//

import Foundation

enum WadType: String {
    case iwad = "IWAD"
    
    static func from(data: Data) -> WadType? {
        guard let typeDefinition = String(data: data, encoding: String.Encoding.ascii)?.uppercased() else {
            return nil
        }
        
        return WadType.init(rawValue: typeDefinition)
    }
}
