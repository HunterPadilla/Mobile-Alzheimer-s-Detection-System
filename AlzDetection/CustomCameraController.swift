//
//  BeginTestViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/25/24.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class CustomCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"

// MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: Button handlers
    // Record a video
    @IBAction func recordVideo(_ sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // Play the video recorded for the app
    @IBAction func playVideo(_ sender: AnyObject) {
        print("Play a video")
        
        // Find the video in the app's document directory
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
        let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
        print(dataPath.absoluteString)
        let videoAsset = (AVAsset(url: dataPath))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Play the video
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
  
// MARK: UIImagePickerControllerDelegate delegate methods
    // Finished recording a video
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        
        if let pickedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(CustomCameraViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = try? Data(contentsOf: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
            try! videoData?.write(to: dataPath, options: [])
            print("Saved to " + dataPath.absoluteString)
        }
        
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // Any tasks you want to perform after recording a video
    @objc func videoWasSavedSuccessfully(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                // What you want to happen
            })
        }
    }
    
 
// MARK: Utility methods for app
    // Utility method to display an alert to the user.
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}







//import UIKit
//import AVFoundation
//import Aespa
//
//let session = AVCaptureSession()

//class CustomCameraController: UIViewController {
    
    
    //NEEDS RECONNECTING!!!
//    @IBOutlet weak var currentImage: UIImageView!

    
//    var backFacingCamera: AVCaptureDevice?
//    var frontFacingCamera: AVCaptureDevice?
//    var currentDevice: AVCaptureDevice!
//
//    var stillImageOutput: AVCapturePhotoOutput!
//    var stillImage: UIImage?
//    
//    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//    
//    let captureSession = AVCaptureSession()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Action methods
//    
//    @IBAction func capture(sender: UIButton) {
//        // Set photo settings
//        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        photoSettings.isHighResolutionPhotoEnabled = true
//        photoSettings.flashMode = .auto
//        
//        stillImageOutput.isHighResolutionCaptureEnabled = true
//        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
//    }
//    
//    private func configure() {
//        // Preset the session for taking photo in full resolution
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//        
//        // Get the front and back-facing camera for taking photos
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
//        
//        for device in deviceDiscoverySession.devices {
//            if device.position == .back {
//                backFacingCamera = device
//            } else if device.position == .front {
//                frontFacingCamera = device
//            }
//        }
//        
//        currentDevice = backFacingCamera
//        
//        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
//            return
//        }
//        
//        // Configure the session with the output for capturing still images
//        stillImageOutput = AVCapturePhotoOutput()
//        
//        // Configure the session with the input and the output devices
//        captureSession.addInput(captureDeviceInput)
//        captureSession.addOutput(stillImageOutput)
//        
//        // Provide a camera preview
//        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(cameraPreviewLayer!)
//        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        cameraPreviewLayer?.frame = view.layer.frame
//        
//        var defaultVideoDevice: AVCaptureDevice? = AVCaptureDevice.systemPreferredCamera
//
//        let userDefaults = UserDefaults.standard
//        if !userDefaults.bool(forKey: "setInitialUserPreferredCamera") || defaultVideoDevice == nil {
//            let backVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
//                                                                                   mediaType: .video, position: .back)
//            
//            defaultVideoDevice = backVideoDeviceDiscoverySession.devices.first
//            
//            AVCaptureDevice.userPreferredCamera = defaultVideoDevice
//            
//            userDefaults.set(true, forKey: "setInitialUserPreferredCamera")
//        }
//        
//        // Bring the camera button to front
//        view.bringSubviewToFront(cameraButton)
//        DispatchQueue.global(qos: .background).async {
//                self.captureSession.startRunning()
//            }
//        
//
//        
//    }
//    
//    
//}
//
//extension CustomCameraController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil else {
//            return
//        }
//        
//        // Get the image from the photo buffer
//        guard let imageData = photo.fileDataRepresentation() else {
//            return
//        }
//        
//        stillImage = UIImage(data: imageData)
//    }
//}


