//
//  BaseScanViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/09.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import AVFoundation

class BaseScanViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate
{
    // MARK: - Outlets
    @IBOutlet weak var view_scanner_container:UIView!
    
    @IBOutlet weak var view_hide_scanner:UIView!
    
    @IBOutlet weak var button_scan:UIButton!
    
    // MARK: - Class attributes
    var _video_preview_layer:AVCaptureVideoPreviewLayer?
    var _capture_session:AVCaptureSession?

    var _inited_scanner:Bool = false
    
    var _waited_first_subview_layout:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        print("viewDidLayoutSubviews : ", self.view_scanner_container.frame)
        
        if !self._inited_scanner && self._waited_first_subview_layout
        {
            self._inited_scanner = true
            var canStart:Bool = false
            
            do
            {
                let captureDevice:AVCaptureDevice? = AVCaptureDevice.default(for: .video)
                if captureDevice != nil
                {
                    let captureDeviceInput:AVCaptureDeviceInput? = try AVCaptureDeviceInput.init(device: captureDevice!)
                    
                    if captureDeviceInput != nil
                    {
                        self._capture_session = AVCaptureSession()
                        self._capture_session!.addInput(captureDeviceInput!)
                        
                        let captureMedataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
                        self._capture_session!.addOutput(captureMedataOutput)
                        
                        captureMedataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        captureMedataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93,AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8]
                        
                        self._video_preview_layer = AVCaptureVideoPreviewLayer(session: self._capture_session!)
                        self._video_preview_layer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        self._video_preview_layer!.frame = self.view_scanner_container.frame
                        
                        self.view_scanner_container.layer.addSublayer(self._video_preview_layer!)
                        
                        canStart = true
                    }
                }
            }
            catch
            {
                print("Error Device Input")
            }
            
            if !canStart
            {
                self.showSimpleAlert(message: NSLocalizedString("error_starting_qr_capture", comment: ""))
            }
        }
        else if !self._waited_first_subview_layout
        {
            self._waited_first_subview_layout = true
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "outputVolume"
        {
            let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(true)
            audioSession.removeObserver(self, forKeyPath: "outputVolume")
            
            self.button_scan.sendActions(for: .touchUpInside)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        
        let text:String? = textField.text
        
        if text != nil
        {
            if text! != ""
            {
                textField.text = ""

                self.enteredTextfieldData(data: text!)
            }
        }
        return true
    }
    
    @IBAction func clickedStartScan(sender:UIButton) -> Void
    {
        if self._capture_session != nil
        {
            if !self._capture_session!.isRunning
            {
                self._capture_session!.startRunning()
                
                self.button_scan.isHidden = true
                
                self.view_hide_scanner.isHidden = true
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if metadataObjects.count > 0
        {
            let metadataObj:AVMetadataMachineReadableCodeObject? = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            if metadataObj != nil
            {
                if self.tryLock()
                {
                    let metadataStr:String? = metadataObj!.stringValue
                    
                    if metadataStr != nil
                    {
                        self.captureSessionMedataFound(data: metadataStr!)
                    }
                }
            }
        }
    }
    
    func captureSessionMedataFound(data:String) -> Void
    {
        self.button_scan.isHidden = false
        
        self.view_hide_scanner.isHidden = false
        
        if self._capture_session != nil
        {
            self._capture_session?.stopRunning()
        }
    }
    
    func enteredTextfieldData(data:String) -> Void
    {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
