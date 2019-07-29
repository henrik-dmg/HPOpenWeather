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
    
    @IBAction func retryWeather(_ sender: UIButton) {
        weatherView.requestWeather(for: weatherView.lastLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weatherView.apiKey = "a8079f7388cb52b6ec144a2727c7c08b"
        weatherView.requestLocationAccess()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

