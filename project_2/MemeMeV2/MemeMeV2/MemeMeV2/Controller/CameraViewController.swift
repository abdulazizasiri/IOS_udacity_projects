//
//  CameraViewController.swift
//  MemeMeV2
//
//  Created by Abdulaziz Asiri on 5/2/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

import AVFoundation // We want toaccessthr camera.


class CameraViewController: UIViewController {
    

    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         initilize()
        
        
    }
    
    func displayCapturedImage(image: UIImage) {
        let memeVC = storyboard?.instantiateViewController(withIdentifier: "MeMeViewController") as! MeMeViewController

        memeVC.trigger = true
        memeVC.capturedImage = image
        navigationController?.pushViewController(memeVC, animated: true)
       dismiss(animated: true, completion: nil)

        
    }
 
     func initilize() {
         session.sessionPreset = AVCaptureSession.Preset.high
         camera = AVCaptureDevice.default(for: AVMediaType.video)
         do {
             let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
             cameraCaptureOutput = AVCapturePhotoOutput()
             session.addInput(cameraCaptureInput)
             session.addOutput(cameraCaptureOutput!)

         } catch {
             print(error)
         }
    
         cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
         cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
         cameraPreviewLayer?.frame = view.bounds
         cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
         view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
         
         session.startRunning()
         
     }
    
    func takePicture(){
               let settings = AVCapturePhotoSettings()
            cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
            
           }
    

    @IBAction func takePhoto(_ sender: Any) {
        takePicture()
    }
    

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let unwrappedError = error {
            print(unwrappedError.localizedDescription)
        } else {
            if let sampleBuffer = photoSampleBuffer, let dataImage  = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)  {
                if let finalImage = UIImage(data: dataImage) {
                    // Display image
                    displayCapturedImage(image: finalImage)
                }
            }
        }
    }
}
