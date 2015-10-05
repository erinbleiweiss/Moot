//
//  ViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 9/22/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

import Alamofire

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let session: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var highlightView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin,
                                            UIViewAutoresizing.FlexibleBottomMargin,
                                            UIViewAutoresizing.FlexibleLeftMargin,
                                            UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.redColor().CGColor
        
        self.highlightView.layer.borderWidth = 3
        
        
        // Add it to our controller's view as a subview
        self.view.addSubview(self.highlightView)
        
        
        // Camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
//        // Nilable NSError to hand off to next method
//        var error: NSError? = nil
        
//        let input: AVCaptureInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        do {
            let input = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
            
            // If input is not nil then add it to the session
            session.addInput(input)
            
        } catch let error as NSError{
            print(error)
        }
        
//        // If input is not nil then add it to the session
//        if input != nil {
//            session.addInput(input)
//        } else {
//            print(error)
//        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
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
                    
                    let barcodeObject = metadata as! AVMetadataMachineReadableCodeObject
                    highlightViewRect = barcodeObject.bounds
                    detectionString = (barcodeObject).stringValue
//                    print(detectionString)
                    
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.session.stopRunning()
                    break
                }
            }
        }
        
        

        getProduct(detectionString){ responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            self.alert(responseObject!)
        }
        
        self.highlightView.frame = highlightViewRect
        
        self.view.bringSubviewToFront(self.highlightView)
    }
    
    func getProduct(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        Alamofire.request(.GET,  "http://www.searchupc.com/handlers/upcsearch.ashx", parameters: ["request_type": "3", "access_token": "EDDD50C8-9FC4-48D0-B29A-1E1EF405283A", "upc": upc]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let name = json["0"]["productname"].string{
                completionHandler(responseObject: name, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }

        
            
            
        }

    }
    
    func alert(Code: String){
        let actionSheet:UIAlertController = UIAlertController(title: "Barcode", message: "\(Code)", preferredStyle: UIAlertControllerStyle.Alert)
        
        // for alert add .Alert instead of .Action Sheet
        // start copy
        let firstAlertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
            {
                (alertAction:UIAlertAction!) in
                // action when pressed
                self.session.startRunning()
        })
        actionSheet.addAction(firstAlertAction)
        
        // end copy
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

