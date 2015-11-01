//
//  GenericCameraViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

import Alamofire

protocol CameraDelegate {
    func doAfterScan(upc: String)
}

class GenericCameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var highlightView: UIView = UIView()                // Rectangle which surrounds detected barcode

    var hostname = Networking.networkConfig.hostname
    var rest_prefix = Networking.networkConfig.rest_prefix
    
    var delegate: CameraDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow the view to resize freely
        self.highlightView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin,
            UIViewAutoresizing.FlexibleBottomMargin,
            UIViewAutoresizing.FlexibleLeftMargin,
            UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        self.view.addSubview(self.highlightView)
        self.view.bringSubviewToFront(self.highlightView)
        
        
        // Camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
            // If input is not nil then add it to the session
            session.addInput(input)
        } catch let error as NSError{
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer!)
        
        // Start capture
        session.startRunning()
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRectZero
        var detectionString : String!

        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                if metadata.type == barcodeType {
                    
                    let barcodeObject = previewLayer?.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                    
                    highlightViewRect = barcodeObject.bounds
                    detectionString = (barcodeObject).stringValue
                    
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.session.stopRunning()
                    break
                }
            }
            
        }
        
        // Show preview rectangle
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        
        doAfterScan(detectionString)
        
    }
    
    func doAfterScan (upc: String){
        delegate?.doAfterScan(upc)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
