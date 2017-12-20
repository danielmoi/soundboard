//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Daniel Moi on 18/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    var audioRecorder: AVAudioRecorder? = nil
    
    var audioURL: URL?
    
    var audioPlayer: AVAudioPlayer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        
        playButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            // 1. create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            
            // this allows us to play through the speakers
            try session.overrideOutputAudioPort(.speaker)
            
            // 2. create URL for the audio file
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            
            print("###########")
            print(audioURL)
            
            
            // 3. create settings for audio recorder
            var settings: [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // 4. create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if (audioRecorder!.isRecording) {
            // Stop the recording
            audioRecorder?.stop()
            
            
            // Change button title to "Record"
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
        } else {
            // Start the recording
            audioRecorder?.record()
            
            // Change button title to "Stop"
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
        }
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch let error {
            print(error)
        }
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    
}
