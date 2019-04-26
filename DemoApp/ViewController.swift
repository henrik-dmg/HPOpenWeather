//
//  ViewController.swift
//  DemoApp
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import UIKit
import HPOpenWeather

class ViewController: UIViewController {

    var api: HPOpenWeather?
    var apiKey: String = "--- USE YOUR OWN API KEY HERE ---"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api = HPOpenWeather(apiKey: apiKey)
        // Do any additional setup after loading the view.
    }
}

