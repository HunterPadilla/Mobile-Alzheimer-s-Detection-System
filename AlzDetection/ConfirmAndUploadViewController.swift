//
//  ConfirmAndUploadViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 3/27/24.
//

import UIKit
import AWSS3
import MobileCoreServices
import AVFoundation
import Amplify

import QuickPoseCore

class ConfirmAndUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    let quickPosePP = QuickPosePostProcessor(sdkKey: "01HS7MB9E2ZSGS2ZXW5PQQ0J3B")
    var videoURL = tmpVar.videoURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "uploadSuccess", sender: self)
        
///Following is commented out for demo functionality, but is meant to select the video from the users library for upload process
//        imagePicker.sourceType = .photoLibrary
//        
//        //Ignore these deprecation warnings for kUTTypeMovie
//        imagePicker.mediaTypes = [kUTTypeMovie as String]
//        present(imagePicker, animated: true, completion: nil)
//        

    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : URL]) async {
        //Ignore these deprecation warnings for kUTTypeMovie
            guard let mediaType = info[.mediaType] as? String, mediaType == kUTTypeMovie as String else {
                print("Selected file is not a video")
                return
            }

            guard let videoURL = info[.mediaURL] else {
                print("Failed to get video URL")
                return
            }
        
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func testCompleted(_ sender: Any) async {
        
        //VideoURL.absoluteString takes the URL as a string
        let request = QuickPosePostProcessor.Request(
            input: Bundle.main.url(forResource: videoURL?.absoluteString, withExtension: nil)!,
            output: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(videoURL!.absoluteString),
            outputType: .mov)
        
        //Sets the Features we are attempting to collect data from
        let features: [QuickPose.Feature] = [.rangeOfMotion(.hip(side: .right, clockwiseDirection: true), style: QuickPose.Style(relativeFontSize: 0.5, relativeArcSize: 0.5, relativeLineWidth: 0.5))]
        
        
        //Finally we can process the file.
        print("Processing \(request.input.lastPathComponent) -> \(request.output)")
        do {
            try quickPosePP.process(features: features, isFrontCamera: true, request: request) { progress, time, _, _, features, _, _ in
                let fileProcessingProgress = Int(progress * 100)
                if let feature = features.first {
                    print("\(fileProcessingProgress)%, \(feature.key.displayString) \(feature.value.stringValue)")
                } else {
                    print("\(fileProcessingProgress)%")
                }
            }
        } catch {
            print("\(request.input.lastPathComponent): file could not be processed: \(error)")
        }
        
        
        
        
        
        
    }
    
    func documentDirectory() -> URL {
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      return documentsDirectory
    }
    
}

///Below is code that might help in the future based on previous application versions.

///Creates the video as a URL
//var videoAndImageReview = UIImagePickerController()
//var videoURL: URL?
//
////Image Picker Controller allows you to pick the video from your library for display purposes if necessary
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    dismiss(animated: true, completion: nil)
//    
//    guard
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
//        //LEAVE kUTTypeMove even though theres a warning!! trying to fix the warning complicates the code and causes bugs
//        mediaType == kUTTypeMovie as String,
//        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
//    else {
//        print("Error: Unable to get the video URL.")
//        return
//    }
//    
//    videoURL = url
//
//    PHPhotoLibrary.shared().performChanges({
//        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
//    }) { success, error in
//        if success {
//            print("Video saved successfully.")
//        } else {
//            print("Error saving video: \(error?.localizedDescription ?? "Unknown error")")
//        }
//    }
//}
//
////This function allows the program to check in case the vide finished saving correctly, and if not show the console why.
//@objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
//    let title = (error == nil) ? "Success" : "Error"
//    let message = (error == nil) ? "Video was saved" : "Video failed to save"
//    
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//    present(alert, animated: true, completion: nil)
//}
//
//func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    dismiss(animated: true, completion: nil)
//}
//
////Brings up the Video review so you could scroll through or even crop your video before saving / viewing.
//func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    if let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
//        videoURL = url
//        print("videoURL: \(String(describing: videoURL))")
//    }
//    dismiss(animated: true, completion: nil)
//}

///THIS CODE WAS MEANT TO UPLOAD A VIDEO TO S3, IT HAS SINCE BEEN REPLACED BUT KEPT FOR POSSIBLE FUTURE REFERENCE
//let dataString = "My Data"
//        let fileNameKey = "myFile.txt"
//        guard let filename = FileManager.default.urls(
//            for: .documentDirectory,
//            in: .userDomainMask
//        ).first?.appendingPathComponent(fileNameKey)
//        else { return }
//
//        do {
//            try dataString.write(
//                to: filename,
//                atomically: true,
//                encoding: .utf8
//            )
//
//            let uploadTask = Amplify.Storage.uploadFile(
//                key: fileNameKey,
//                local: videoURL!
//            )
//
//            Task {
//                for await progress in await uploadTask.progress {
//                    print("Progress: \(progress)")
//                }
//            }
//
//            let data = try await uploadTask.value
//            print("Completed: \(data)")
//        } catch {
//            print("Error: \(error)")
//        }
