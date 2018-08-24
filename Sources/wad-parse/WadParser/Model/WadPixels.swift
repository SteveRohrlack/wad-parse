//
//  WadPixels.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 20.08.18.
//

import Foundation

struct WadPixels: Array2DMapping {
    
    public typealias ValueType = UInt8
    
    let columns: Int
    let rows: Int
    internal(set) var values: [ValueType?]
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        self.values = [ValueType?](repeating: nil, count: columns * rows)
    }
    
    func colored(colormap: WadColormap, palette: WadPalette) -> [RGBA?] {
        return values.map {
            guard let pixelValue = $0 else {
                return nil
            }
            
            // use pixel value to get colormap value to get palette color
            
            let colormapValue = Int(colormap.values[Int(pixelValue)])
            
            return palette.colorComponents[colormapValue]
        }
    }
    
}
