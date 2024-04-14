//
//  MIDIManager.swift
//  VirtualMidiController
//
//  Created by Alejandro Hernandez on 13/04/24.
//

import CoreMIDI


class MIDIManager {
    var client = MIDIClientRef()
    var outputPort = MIDIPortRef()
    var virtualEndpoint = MIDIEndpointRef()
    var logicDestination: MIDIEndpointRef = 0 // Initialize to 0
    
    
    init() {
        // Create a MIDI Client
        MIDIClientCreate("Alex Client" as CFString, nil, nil, &client)
        
        // Create the virtual endpoint
        let virtualName = "Alex MIDI" as CFString
        MIDISourceCreate(client, virtualName, &virtualEndpoint)
        
    }
    func sendMIDIMessage(note: UInt8, velocity: UInt8, channel: UInt8) {
//        guard let noteNumber = pitchToMIDINoteNumber(pitch: note) else {
//            print("Invalid note name")
//            return
//        }
        
        var packet = MIDIPacket()
        packet.timeStamp = 0
        packet.length = 3
        packet.data.0 = 0x90   // Note On message status byte with channel
        packet.data.1 = note       // Note number (0-127)
        packet.data.2 = velocity         // Velocity (0-127)
        
        let packetList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
        packetList.pointee.numPackets = 1
        packetList.pointee.packet = packet
        
        MIDISend(0, virtualEndpoint, packetList)
        
        print("Sending MIDI message - Note: \(note), Velocity: \(velocity), Channel: \(channel)")
    }
    
    func pitchToMIDINoteNumber(pitch: String) -> UInt8? {
        // Dictionary mapping note names to MIDI note numbers
        let noteNumberForPitch: [String: UInt8] = [
            "C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6, "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11
        ]
        
        // Split pitch into note name and octave
        let components = pitch.components(separatedBy: "-")
        guard components.count == 2 else { return nil }
        
        let noteName = components[0]
        let octave = components[1]
        
        // Calculate MIDI note number
        guard let noteNumber = noteNumberForPitch[noteName], let octaveValue = Int(octave) else { return nil }
        let midiNoteNumber = UInt8(noteNumber) + UInt8((octaveValue + 1) * 12)
        print(midiNoteNumber)
        return midiNoteNumber
    }
    
    private func noteToMIDINoteNumber(note: String) -> UInt8? {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let components = note.components(separatedBy: " ")
        guard components.count == 3,
              let noteName = components.first,
              let octave = Int(components[1]),
              let velocity = UInt8(components[2]),
              let noteIndex = noteNames.firstIndex(of: noteName) else {
            return nil
        }
        let noteNumber = UInt8((octave + 1) * 12 + noteIndex)
        return noteNumber
    }
    
}
