//
//  BeginTestViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/25/24.
//

import UIKit
import SwiftUI
import QuickPoseCore
import QuickPoseCamera
import ReplayKit


struct tmpVar{
    static var tmp = true;
    static var videoURL: URL?
}
class CustomCameraViewController: UIViewController, UINavigationControllerDelegate {
    
    var camera: QuickPoseCamera?
    var simulatedCamera: QuickPoseSimulatedCamera?
    var quickPose = QuickPose(sdkKey: "01HS7MB9E2ZSGS2ZXW5PQQ0J3B") // register for your free key at https://dev.quickpose.ai
   
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var overlayView: UIImageView!
    
    var screenRecorder = RPScreenRecorder.shared()
    
    //This Function is triggered when the user taps the screen
    @objc func tapClick(){
        //Stops the current screen recording, allows the user to save the screen recording to the phone
        //TODO: Once the recording is FULLY complete, upload to S3
        stopScreenRecording()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = QuickPoseCamera(useFrontCamera: true) // setup camera
        try? camera?.start(delegate: quickPose)
        
        let customPreviewLayer = AVCaptureVideoPreviewLayer(session: camera!.session!)
        customPreviewLayer.videoGravity = .resizeAspectFill
        customPreviewLayer.frame.size = view.frame.size
        cameraView.layer.addSublayer(customPreviewLayer)
        
        // setup overlay
        overlayView.contentMode = .scaleAspectFill // keep overlays in the same scale as camera output
        overlayView.frame.size = view.frame.size
        
        // Initialize screen recorder
        screenRecorder = RPScreenRecorder.shared()
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapClick))
        
        tmpVar.tmp = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(overlayView)
        
        quickPose.start(features: [.overlay(.wholeBody)], onFrame: { status, image, record, feedback, landmarks in
            DispatchQueue.main.async {
                self.overlayView.image = image
            }
            if case .success = status {
                if(tmpVar.tmp == true){
                    // Start screen recording when the view appears
                    self.startScreenRecording()
                    tmpVar.tmp = false
                    
                }
                
                
            } else {
                // show error feedback
            }
        })
        
    }
    
    //When the View Dissapears (likely due to segue) end the camera usage and quickpose overlay
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera?.stop()
        quickPose.stop()
    }
    


    // Function to start screen recording
    func startScreenRecording() {
        guard screenRecorder.isRecording == false else {
            print("Screen recording is already in progress.")
            return
        }
        
        screenRecorder.startRecording { [] error in
            if let error = error {
                print("Failed to start recording: \(error.localizedDescription)")
            }
        }
    }

    // Function to stop screen recording
    func stopScreenRecording(){
    
        tmpVar.videoURL = tempURL()
        screenRecorder.stopRecording(withOutput: tmpVar.videoURL!) { (error) in
                guard error == nil else{
                    print("Failed to save ")
                    return
                }
            
            print(tmpVar.videoURL!)
            }
        performSegue(withIdentifier: "recordingSaved", sender: self)
            
            
          
        
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
            
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    
}


    
// Extension to handle RPPreviewViewControllerDelegate methods
extension CustomCameraViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        
        // Dismiss the preview controller
        previewController.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "recordingSaved", sender: self)
        })
       
    }
    
}
    
///Below is code that might assist in the future based on previous application versions
///
///
////Code to enable TTS, Import AVFoundation and copy paste where needed
//let synthesizer = AVSpeechSynthesizer()
//
//func readTextAloud(){
//    
//    //Complete the String with whatever you want to say.
//    let utterance = AVSpeechUtterance(string: "To prepare for task #1, please step three to five feet away from your phone at an angle where your camera can see you. Press record button to start, and return to your desired testing position.")
//    
//    //Language Settings for TTS
//    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//    
//    //Speed of TTS (0.4 is just slightly slower than normal talking speed)
//    utterance.rate = 0.4
//    
//    //Begins the TTS
//    synthesizer.speak(utterance)
//}



    




