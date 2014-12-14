//
//  Sound.swift
//  AudioRecorder
//
//  Created by Vincenzo Favara on 17/11/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation
import CoreData

class Sound: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var url: String

}
