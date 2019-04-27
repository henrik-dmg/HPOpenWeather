//
//  ViewController.swift
//  DemoApp macOS
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Cocoa
import HPOpenWeather

class ViewController: NSViewController {

    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var conditionLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var locationAccessButton: NSButton!
    
    var apiKey = "--- YOUR API KEY GOES HERE ---"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func requestLocationAccess(_ sender: Any) {
        
    }
    
}

