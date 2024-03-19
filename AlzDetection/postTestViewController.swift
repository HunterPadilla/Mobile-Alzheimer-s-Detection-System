//
//  UploadVideoViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 2/11/24.
//

import UIKit
import AVFoundation

class postTestViewController: UIViewController {

    
    
    
    //Code to enable TTS, Import AVFoundation and copy paste where needed
    var synthesizer = AVSpeechSynthesizer()
    
    func readTextAloud(){
        //Complete the String with whatever you want to say.
        let utterance = AVSpeechUtterance(string: "Great work on completing AwareMinds audio instructed test. The video you recorded has been sent to our AI and is being evaluated! Tap the Green button to View your Results, or, Tap the Blue button to return to the main menu")
        
        //Language Settings for TTS
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        //Speed of TTS (0.4 is just slightly slower than normal talking speed)
        utterance.rate = 0.4
        
        //Begins the TTS
        synthesizer.speak(utterance)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTextAloud()
        // Do any additional setup after loading the view.
    }
    @IBAction func viewResultsButton(_ sender: Any) {
        performSegue(withIdentifier: "resultsButton", sender: self)
    }
    
    @IBAction func triggerMainMenuSegue(_ sender: Any) {
            guard let MainMenu = storyboard? .instantiateViewController(withIdentifier: "MainMenu") as? HomeViewController else {
                return
            }
            present(MainMenu, animated: true)
        }
    }
    
   

