//
//  WadSoundSpeaker.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 22.08.18.
//

import Foundation

struct WadSoundSpeaker: WadLumpContent {
    
    // doom uses a internal refresh rate of 35
    // 4 times as many tones can be played in one second (=140)
    // therefore a tone corresponds to a time value of 1/140
    
    static let toneLengthInSeconds: Float = 1/140
    static let sampleRate = 8000
    
    struct Tone {
        
        static let lowestPossibleFrequency: Float = 174.61
        static let multiplier: Float = pow(2, (1/12))
        
        let value: UInt8
        
        var isSelent: Bool {
            return value == 0
        }
        
        func frequency(pitchedBy pitch: UInt8 = 0) -> Float {
            guard value > 0 else {
                return 0
            }
            
            return Tone.lowestPossibleFrequency * pow(Tone.multiplier, Float(value + pitch - 1) / 2)
        }
    }
    
    let name: String
    let tones: [Tone]
    
}
