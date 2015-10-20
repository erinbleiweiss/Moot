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

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var highlightView: UIView = UIView()                // Rectangle which surrounds detected barcode
    var productName: String!                            // Name of product scanned
    
    var hostname = Networking.networkConfig.hostname
    var rest_prefix = Networking.networkConfig.rest_prefix
    
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
        print(highlightViewRect)
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        
        getProduct(detectionString){ responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            self.productName = responseObject!
            self.performSegueWithIdentifier("barcodeScannedSegue", sender: nil)
        }
        
    }
    
    
    // Get product name from UPC
    func getProduct(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_product_name"
        Alamofire.request(.GET, url, parameters: ["upc": upc]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let name = json["product_name"].string{
                completionHandler(responseObject: name, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
            
        }
        
    }
    

    // Send product name back to TestLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! TestLevelViewController
        destinationVC.productName = self.productName
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

