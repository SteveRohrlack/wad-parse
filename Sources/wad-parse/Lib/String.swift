//
//  String.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 02.08.18.
//

extension String {
    
    func matches(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
}
