//
//  InstructionsViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit
import AVFoundation

class InstructionsViewController: UIViewController {
    
    //Code to enable TTS, Import AVFoundation and copy paste where needed
    var synthesizer = AVSpeechSynthesizer()
    
    func readTextAloud(){
        
        //Complete the String with whatever you want to say.
        let utterance = AVSpeechUtterance(string: "On the next screen, you will first be shown an example task. Once you confirm that you are ready, you will be asked to perform the example task that was shown before moving on to the next task.")
        
        //Language Settings for TTS
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        //Speed of TTS (0.4 is just slightly slower than normal talking speed)
        utterance.rate = 0.4
        
        //Begins the TTS
        synthesizer.speak(utterance)
    }
    

    
    @IBAction func cancelTestButton(_ sender: Any) {
        performSegue(withIdentifier: "instructionsCancel", sender: self)
    }
    
    @IBAction func beginTestButton(_ sender: Any) {
        performSegue(withIdentifier: "instructionsConfirm", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Calls the TTS function on screen load.
        readTextAloud()
        
    }
    

}
