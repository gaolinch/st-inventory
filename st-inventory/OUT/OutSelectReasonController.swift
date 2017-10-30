//
//  OutSelectReasonController.swift
//  st-inventory
//
//  Created by Philippe Benedetti on 23/10/17.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import AVFoundation

class OutSelectReasonController: UIViewController {

    var scannedCode:NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        print(scannedCode!)
        
        
        // Setup label and button layout
        view.addSubview(codeLabel)
        codeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        codeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        if let scannedCode = scannedCode {
//            codeLabel.text = scannedCode
//        }
        
        view.addSubview(scanButton1)
        scanButton1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        scanButton1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scanButton1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        view.addSubview(scanButton2)
        scanButton2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        scanButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scanButton2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        
        view.addSubview(scanButton3)
        scanButton3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        scanButton3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scanButton3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.textAlignment = .center
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    lazy var scanButton1:UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.backgroundColor = .orange
        scanButton.layer.cornerRadius = 25
        scanButton.addTarget(self, action: #selector(displayScannerViewController), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scanButton
    }()
    
    
    lazy var scanButton2:UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.backgroundColor = .orange
        scanButton.layer.cornerRadius = 25
        scanButton.addTarget(self, action: #selector(displayScannerViewController), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scanButton
    }()
    
    lazy var scanButton3:UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.backgroundColor = .orange
        scanButton.layer.cornerRadius = 25
        scanButton.addTarget(self, action: #selector(displayScannerViewController), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scanButton
    }()
    
    @objc func displayScannerViewController() {
        print("123")
        let scanViewController = OutScanProductController()
        //navigationController?.pushViewController(scanViewController, animated: true)
        //navigationController?.present(scanViewController, animated: true, completion: nil)
        present(scanViewController, animated: true, completion: nil)
    }
    
    
}

