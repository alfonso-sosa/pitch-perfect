//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alfonso Sosa on 16/03/15.
//  Copyright (c) 2015 Alfonso Sosa. All rights reserved.
//

import UIKit
import AVFoundation

//The controller for the second screen, that has the playback functionality
class PlaySoundsViewController: UIViewController {
    
    //Instances used for playing audio
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    //RecordedAudio model
    var receivedAudio: RecordedAudio!

    //Performed the first time the screen is loaded, the engine, file and player are initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Stops any current playback and plays the file from time 0 with the specified rate
    func playSound(rate: Float){
        self.stop()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    //Invoked by the snail image on screen. Plays the file with a 0.5 (slow) rate.
    @IBAction func playSnailSound(sender: UIButton) {
        playSound(0.5)
    }

    //Invoked by the rabbit image on screen. Plays the file with a 2.0 (fast) rate.
    @IBAction func playRabbitSound(sender: UIButton) {
        playSound(2.0)
    }
    
    //Stops any currently playing audio and plays the file with the specified pitch.
    func playAudioWithVariablePitch(pitch: Float){
        self.stop()
        
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        
        var auTimePitch = AVAudioUnitTimePitch()
        auTimePitch.pitch = pitch
        audioEngine.attachNode(auTimePitch)
        
        //Audio engine nodes are connected to chain effects into an output (speakers)
        audioEngine.connect(playerNode, to: auTimePitch, format: nil)
        audioEngine.connect(auTimePitch, to: audioEngine.outputNode, format: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        playerNode.play()
    }
    
    //Invoked from the chipmunk button. Plays back file using a high pitch.
    @IBAction func playChipmunkSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    //Invoked from the darth vader button. Plays back file using a very low pitch.
    @IBAction func playDarthVaderSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    //Invoked from the stop button, stops playback
    @IBAction func stop(sender: UIButton) {
        self.stop()
    }
    
    //Stops the currently playing audio.
    func stop(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
