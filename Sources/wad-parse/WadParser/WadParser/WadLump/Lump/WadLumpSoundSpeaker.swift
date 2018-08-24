//
//  WadLumpSoundSpeaker.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 22.08.18.
//
//  see http://doom.wikia.com/wiki/PC_speaker_sound_effects
//  see https://www.doomworld.com/idgames/sounds/pcspkr10

import Foundation

struct WadLumpSoundSpeaker: WadLump {
    
    static let headerLengthInBytes: UInt32 = 4
    
    let lumpOffset: UInt32
    let lumpSize: UInt32
    let name: String
    let categories: Set<WadLumpCategory>
    
    func content(in wadData: Data) -> WadLumpContent? {
        let lumpData = readData(in: wadData)
        
        // the length is actually stored as Int16 starting at the third byte
        // but can also easily be calculated from the lump size (minus the header length)
        
        // let length: Int16 = lumpData.intValue(at: 2)
        
        let tones: [WadSoundSpeaker.Tone] = (WadLumpSoundSpeaker.headerLengthInBytes..<lumpSize).map { (toneIndex) in
            return WadSoundSpeaker.Tone(value: lumpData.intValue(at: Int(toneIndex)))
        }
        
        return WadSoundSpeaker(name: name, tones: tones)
    }
    
}
