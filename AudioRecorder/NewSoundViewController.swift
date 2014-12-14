//
//  NewSoundViewController.swift
//  AudioRecorder
//
//  Created by Vincenzo Favara on 14/11/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
    

import Foundation
import AVFoundation
import CoreData

class NewSoundViewController: UIViewController  {
    
    required init(coder aDecoder: NSCoder) {
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        self.session = AVAudioSession.sharedInstance()
        self.session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.setActive(true, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)!
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var uiTextName: UITextField!
    @IBOutlet weak var uiButtonRecord: UIButton!
    
    var audioRecorder :AVAudioRecorder
    var audioURL: String
    var previusViewController = SoundListViewController()
    var session: AVAudioSession
    
    @IBAction func recordAction(sender: AnyObject) {
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.uiButtonRecord.setTitle("Record", forState: UIControlState.Normal)
        } else {
            self.audioRecorder.record()
            self.uiButtonRecord.setTitle("Stop recording", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
        }
        
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        var sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as Sound

        sound.name = uiTextName.text
        sound.url = audioURL
        
        context.save(nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}