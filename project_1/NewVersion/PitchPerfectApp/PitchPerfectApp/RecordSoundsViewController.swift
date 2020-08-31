//
//  RecordSoundsViewController.swift
//  PitchPerfectApp
//
//  Created by Abdulaziz Asiri on 4/26/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//
// Reviewer notes: Fixeed the sixe of the recorder button
// 
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        stopRecordingButton.isEnabled = false
    }


    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configureUI(recording: true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
           configureUI(recording: false)
             audioRecorder.stop()
             let audioSession = AVAudioSession.sharedInstance()
             try! audioSession.setActive(false)
    }
    
    func configureUI(recording: Bool) {
        
    recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
    stopRecordingButton.isEnabled = recording
    recordButton.isEnabled = !recording
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("finish recording")
        } else {
            print("cording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

