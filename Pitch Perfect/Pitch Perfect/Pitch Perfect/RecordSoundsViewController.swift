//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alfonso Sosa on 10/03/15.
//  Copyright (c) 2015 Alfonso Sosa. All rights reserved.
//

import UIKit
import AVFoundation

//The controller for the first screen, that allows the user to record audio
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //Record label
    @IBOutlet weak var tapToRecordLabel: UILabel!
    
    //Label to let the user know that the app is currently recording
    @IBOutlet weak var recordingLabel: UILabel!

    //The button that the user presses to begin recording
    @IBOutlet weak var recordButton: UIButton!
    
    //The button the user presses to stop recording
    @IBOutlet weak var stopButton: UIButton!
    
    //AVAudioRecorder, framework class that has the recording functionality
    var audioRecorder: AVAudioRecorder!
    
    //Instance of the model of our app, to keep track of recorded audio.
    var recordedAudio: RecordedAudio!
    
    //Invoked when the controller is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Invoked everytime this controller's view will be shown on screen
    //It sets all the labels and buttons to an initial state, ready for the user to tap 'Begin Recording'
    override func viewWillAppear(animated: Bool) {
        tapToRecordLabel.hidden = false
        stopButton.hidden = true
        recordingLabel.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //IBAction invoked by pressing the record button
    //It shows the 'Recording' label and the button to stop, and then starts the recording process
    @IBAction func recordAudio(sender: UIButton) {
        tapToRecordLabel.hidden = true
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        //Inits and starts the audio recorder, and passes self as a delegate
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //Delegate method, will be invoked when the AVAudioRecorder has finished
    //We performa a segue to the next screen of our application, that will allow the user to play it with sound effects
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathURL: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("error recording")
            tapToRecordLabel.hidden = false
            recordButton.enabled = true
            stopButton.hidden = true
            recordingLabel.hidden = true
        }

    }
    
    //Action performed by the stop button, resets the audio recorder.
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    //When the segue is about to be performed, we pass the RecordedAudio model, to the PlaySoundsViewController.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    

    

}

