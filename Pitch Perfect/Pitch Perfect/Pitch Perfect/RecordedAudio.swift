//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Alfonso Sosa on 26/03/15.
//  Copyright (c) 2015 Alfonso Sosa. All rights reserved.
//

import Foundation

//Application model, represents the audio recorded by AVAudioRecorder, includes the title and path of the file
class RecordedAudio : NSObject {
    
    //Initializer for the Recorded Audio
    init(title: String!, filePathURL: NSURL!) {
        self.title = title
        self.filePathURL = filePathURL
    }
    
    //File path
    var filePathURL: NSURL!
    
    //File title
    var title: String!
    
}
