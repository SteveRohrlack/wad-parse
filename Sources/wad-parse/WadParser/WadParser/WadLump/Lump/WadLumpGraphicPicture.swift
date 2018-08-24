//
//  WadLumpGraphicPicture.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 03.08.18.
//
//  see https://zdoom.org/wiki/Patch
//  see https://doomwiki.org/wiki/Picture_format

import Foundation

struct WadLumpGraphicPicture: WadLump {
    
    typealias Const = WadLumpGraphicPicture
    
    static let headerLengthInBytes = 8
    
    static let pixelColumnEndValue = 255
    
    let lumpOffset: UInt32
    let lumpSize: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        // width
        let columns: UInt16 = lumpData.intValue(at: 0)
        // height
        let rows: UInt16 = lumpData.intValue(at: 2)
        // offsets
        let offsetLeft: Int16 = lumpData.intValue(at: 4)
        let offsetTop: Int16 = lumpData.intValue(at: 6)
        
        // each column (width) of image data is stored separately
        
        // relative column addresses in this lump
        
        let columnAddresses: [UInt32] = (0..<Int(columns)).map { (columnIndex) in
            let columnAddress = Const.headerLengthInBytes + (4 * columnIndex)
            return lumpData.intValue(at: columnAddress)
        }
        
        var pixels = WadPixels(columns: Int(columns), rows: Int(rows))
        
        // iterate columns
        
        for (columnIndex, columnAddressInLump) in columnAddresses.enumerated() {
            
            // each column is either:
            // - a "null" column (indicated by the first byte being 255
            // - composed of one or more "posts"
            
            // address of first post (equals column start address)
            var postAddress = Int(columnAddressInLump)
            
            // first by of first post
            var rowIndexOfFirstPixel: UInt8 = lumpData.intValue(at: postAddress)
            
            // is this a "null" column ?
            if rowIndexOfFirstPixel == Const.pixelColumnEndValue {
                break
            }
            
            // iterate posts in column
            
            repeat {
                // first byte in post is "rowIndexOfFirstPixel"
                
                // second byte in post
                let numberOfPixelsInPost: UInt8 = lumpData.intValue(at: postAddress + 1)
                
                // third byte in post is ignored
                
                // pixel values start from the forth byte in post
                let pixelsStartAddress = postAddress + 3
                let pixelsEndAddress = pixelsStartAddress + Int(numberOfPixelsInPost)
                
                for (pixelIndex, pixelAddress) in (pixelsStartAddress..<pixelsEndAddress).enumerated() {
                    let pixelValue: UInt8 = lumpData.intValue(at: pixelAddress)
                    pixels[columnIndex, Int(rowIndexOfFirstPixel) + pixelIndex] = pixelValue
                }
                
                // next post
                
                // address of next post: 3 bytes (see above) + number of pixels (1 byte each) + 1 additional ignored byte
                postAddress += Int(numberOfPixelsInPost) + 4
                rowIndexOfFirstPixel = lumpData.intValue(at: postAddress)
                
            } while rowIndexOfFirstPixel != Const.pixelColumnEndValue

        }
        
        return WadGraphicPicture(
            name: name,
            width: columns,
            height: rows,
            offsetLeft: offsetLeft,
            offsetTop: offsetTop,
            pixels: pixels
        ) as WadLumpContent
    }
    
}
