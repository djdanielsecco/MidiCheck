//
//  ViewController.swift
//  MidiCheck
//
//  Created by Bubble bolha on 04/04/17.
//  Copyright © 2017 Bubble. All rights reserved.
//

import Cocoa
import CoreMIDI

class ViewController: NSViewController {
    @IBOutlet weak var label1: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func getDisplayName(_ obj: MIDIObjectRef) -> String
        {
            var param: Unmanaged<CFString>?
            var name: String = "Error";
            
            let err: OSStatus = MIDIObjectGetStringProperty(obj, kMIDIPropertyDisplayName, &param)
            if err == OSStatus(noErr)
            {
                name =  param!.takeRetainedValue() as! String
            }
            
            return name;
        }
        
        func getDestinationNames() -> [String]
        {
            var names:[String] = [String]();
            
            let count: Int = MIDIGetNumberOfDestinations();
            for i in 0 ..< count
            {
                let endpoint:MIDIEndpointRef = MIDIGetDestination(i);
                if (endpoint != 0)
                {
                    names.append(getDisplayName(endpoint));
                }
            }
            return names;
        }
        
        var midiClient: MIDIClientRef = 0;
        var outPort:MIDIPortRef = 0;
        
        MIDIClientCreate("MidiTestClient" as CFString, nil, nil, &midiClient);
        MIDIOutputPortCreate(midiClient, "MidiTest_OutPort" as CFString, &outPort);
        
        var packet1:MIDIPacket = MIDIPacket();
        packet1.timeStamp = 0;
        packet1.length = 3;
        packet1.data.0 = 0x90 + 0; // Note On event channel 1
        packet1.data.1 = 0x3C; // Note C3
        packet1.data.2 = 100; // Velocity
        
        var packetList:MIDIPacketList = MIDIPacketList(numPackets: 1, packet: packet1);
        
        let destinationNames = getDestinationNames()
        for (index,destName) in destinationNames.enumerated()
        {
            print("Destination #\(index): \(destName)")
            label1.stringValue += ("Destination #\(index): \(destName)\n")
          
            
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var numeroPorta: NSTextField!
    
   
    @IBOutlet weak var numeroCanal: NSTextField!
    @IBAction func midiTeste(_ sender: NSButton) {
        
        
        
        var midiClient: MIDIClientRef = 0;
        var outPort:MIDIPortRef = 0;
        let DFG = numeroCanal.intValue - 1
        let CHN:UInt8 = UInt8(DFG)
        
        MIDIClientCreate("MidiTestClient" as CFString, nil, nil, &midiClient);
        MIDIOutputPortCreate(midiClient, "MidiTest_OutPort" as CFString, &outPort);
        
        var packet1:MIDIPacket = MIDIPacket();
        packet1.timeStamp = 0;
        packet1.length = 3;
        packet1.data.0 = 0x90 + CHN; // Note On event channel 1
        packet1.data.1 = 0x3C; // Note C3
        packet1.data.2 = 100; // Velocity
        
        var packetList:MIDIPacketList = MIDIPacketList(numPackets: 1, packet: packet1);
        
        let destNum = numeroPorta.intValue
        print("Using destination #\(destNum)")
        
        var dest:MIDIEndpointRef = MIDIGetDestination(Int(destNum));
        print("Playing note for 1 second on channel 1")
        MIDISend(outPort, dest, &packetList);
        packet1.data.0 = 0x80 + CHN; // Note Off event channel 1
        packet1.data.2 = 0; // Velocity
        sleep(2);
        packetList = MIDIPacketList(numPackets: 1, packet: packet1);
        MIDISend(outPort, dest, &packetList);
        print("Note off sent")
        
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

