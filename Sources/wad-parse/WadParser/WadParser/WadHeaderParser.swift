//
//  WadHeaderParser.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 07.08.18.
//

import Foundation

struct WadHeaderParser {
    
    static let lengthInBytes = 12
    static let numberOfLumpsStartAddress = 4
    static let directoryOffsetStartAddress = 8
    
    let wadData: Data
    
    func parse() throws -> WadHeader {
        if wadData.count <= WadHeaderParser.lengthInBytes {
            throw WadParser.Errors.wadContainsNoBody
        }
        
        let headerData = wadData.subdata(in: (0..<WadHeaderParser.lengthInBytes))
        
        let typeAddress: Range<Int> = 0..<WadHeaderParser.numberOfLumpsStartAddress
        
        guard let wadType = WadType.from(data: headerData.subdata(in: typeAddress)) else {
            throw WadParser.Errors.invalidWadType
        }
        
        return WadHeader(
            wadType: wadType,
            numberOfLumps: headerData.intValue(at: WadHeaderParser.numberOfLumpsStartAddress),
            directoryOffset: headerData.intValue(at: WadHeaderParser.directoryOffsetStartAddress)
        )

    }
    
}
