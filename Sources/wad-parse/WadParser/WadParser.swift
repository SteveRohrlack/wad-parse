//
//  File.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 02.08.18.
//

import Foundation

class WadParser {
    
    enum Errors: Error {
        case inputFileNotReadable
        case wadContainsNoBody
        case invalidWadType
        case invalidColorValue
    }
    
    private let inputFilename: String
    private let wadData: Data
    
    convenience init(filePath: String) throws {
        try self.init(fileUrl: URL(fileURLWithPath: filePath))
    }
    
    init(fileUrl: URL) throws {
        guard let data = try? Data(contentsOf: fileUrl, options: .alwaysMapped) else {
            throw Errors.inputFileNotReadable
        }
        
        self.inputFilename = fileUrl.lastPathComponent
        self.wadData = data
    }

    func parse() throws -> Wad {
        let header = try WadHeaderParser(wadData: wadData).parse()
        
        let lumps = try WadLumpParser(wadHeader: header, wadData: wadData).parse()
 
        let wad = Wad(filename: inputFilename, header: header, lumps: lumps, data: wadData)
        
        return wad
    }
    
}
