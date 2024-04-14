//
//  ViewController.swift
//  VirtualMidiController
//
//  Created by Alejandro Hernandez on 13/04/24.
//

import Cocoa

class ViewController: NSViewController {
    
    let midiManager = MIDIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setupView() {
        let button = NSButton(title: "Send MIDI", target: self, action: #selector(sendMIDI))
        button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        view.addSubview(button)
    }
    
    @objc func sendMIDI() {
        midiManager.sendMIDIMessage(note: 27, velocity: 1, channel: 1)
    }
    
}

