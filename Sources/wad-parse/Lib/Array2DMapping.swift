//
//  Array2DMapping.swift
//  CitySimCore
//
//  Created by Steve Rohrlack on 13.05.16.
//

import Foundation

protocol Array2DMapping {
    associatedtype ValueType
    
    var columns: Int { get }
    var rows: Int { get }
    var values: [ValueType?] { get set }
    
    subscript(column: Int, row: Int) -> ValueType? { get set }
}

extension Array2DMapping {
    
    subscript(column: Int, row: Int) -> ValueType? {
        get {
            return values[(row * columns) + column]
        }
        set {
            values[(row * columns) + column] = newValue
        }
    }
    
}
