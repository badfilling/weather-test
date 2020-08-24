//
//  LocationWeatherViewController.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class LocationWeatherViewController: UIViewController {
    let viewModel: LocationWeatherViewModel
    
    init(viewModel: LocationWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        title = "stub for weather"
//        self.navigationItem.back
    }
}
