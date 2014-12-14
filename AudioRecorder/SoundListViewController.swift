//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Vincenzo Favara on 14/11/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SoundListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    var sounds: [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        var request = NSFetchRequest(entityName: "Sound")
        
        self.sounds = context.executeFetchRequest(request, error: nil)! as [Sound]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sound = self.sounds[indexPath.row]
        
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        var pathComponents = [baseString, sound.url]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: audioNSURL, error: nil)
        self.audioPlayer.play()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var sound = self.sounds[indexPath.row]
        var cell = UITableViewCell()
        cell.textLabel?.text = sound.name
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var sound = self.sounds[indexPath.row]
            var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            context.deleteObject(sound)
            
            sounds.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    let INFOVIEWCONTROLLER = "INFO"
    let NEWSOUNDVIEWCONTROLLER = "NEWSOUND"
    var nextViewControllerChoose = ""
    @IBAction func infoAction(sender: AnyObject) {
        nextViewControllerChoose = INFOVIEWCONTROLLER
    }
    @IBAction func addAction(sender: AnyObject) {
        nextViewControllerChoose = NEWSOUNDVIEWCONTROLLER
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if nextViewControllerChoose == INFOVIEWCONTROLLER {
            var nextViewController = segue.destinationViewController as InfoViewController
            nextViewController.previusViewController = self
        } else if nextViewControllerChoose == NEWSOUNDVIEWCONTROLLER {
            var nextViewController = segue.destinationViewController as NewSoundViewController
            nextViewController.previusViewController = self
        } else {
            //do nothing
        }
    }
    
    
}

