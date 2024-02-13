//
//  BeginTestViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/25/24.
//

import UIKit
import MobileCoreServices
import Photos

class CustomCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Creates the video as a URL
    var videoAndImageReview = UIImagePickerController()
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Recording button, allows the program to access camera1 which is only available on Mobile Phones
    @IBAction func RecordAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            //LEAVE kUTTypeMove even though theres a warning!! trying to fix the warning complicates the code and causes bugs
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera Unavailable")
        }
    }
      
    //Image Picker Controller allows you to pick the video from your library for display purposes if necessary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            //LEAVE kUTTypeMove even though theres a warning!! trying to fix the warning complicates the code and causes bugs
            mediaType == kUTTypeMovie as String,
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else {
            print("Error: Unable to get the video URL.")
            return
        }
        
        videoURL = url
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { success, error in
            if success {
                print("Video saved successfully.")
            } else {
                print("Error saving video: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    //This function allows the program to check in case the vide finished saving correctly, and if not show the console why.
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
  
    //The actual button Function for choosing a video for display, calls upon other functions
    @IBAction func openImgVideoPicker() {
        videoAndImageReview.sourceType = .savedPhotosAlbum
        videoAndImageReview.delegate = self
        videoAndImageReview.mediaTypes = ["public.movie"]
        present(videoAndImageReview, animated: true, completion: nil)
    }
    
    //Brings up the Video review so you could scroll through or even crop your video before saving / viewing.
    func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
            videoURL = url
            print("videoURL: \(String(describing: videoURL))")
        }
        dismiss(animated: true, completion: nil)
    }
}

