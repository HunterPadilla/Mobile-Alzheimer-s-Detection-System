//
//  BeginTestViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/25/24.
//

import UIKit
import AVFoundation

class BeginTestViewController: UIViewController {


    private let session = AVCaptureSession()
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.backgroundColor = .secondarySystemBackground
        
        button.backgroundColor = .systemBlue
        button.setTitle("Take Picture", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        //cameraView.session = session
        
       
        
        
    }
    
    
    @IBAction func BeginRecordingButton(_ sender: Any) {
        
        // MARK: Implement Recording Process
        
    }
   
  
    
    
}
