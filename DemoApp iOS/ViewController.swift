//
//  ViewController.swift
//  DemoApp
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherView: WeatherView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weatherView.apiKey = "--- YOUR API KEY GOES HERE ---"
        weatherView.requestLocationAccess()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

