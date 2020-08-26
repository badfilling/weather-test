//
//  UIAlertController+Extensions.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 26/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createCoordinateInput(completion: @escaping ((String?, String?) -> Void)) -> UIAlertController {
        let alertVC = UIAlertController(title: "Custom location", message: "Provide location coordinates.", preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "Latitude"
            textField.keyboardType = .numbersAndPunctuation
        }
        alertVC.addTextField { textField in
            textField.placeholder = "Longitude"
            textField.keyboardType = .numbersAndPunctuation
        }
        let submitAction = UIAlertAction(title: "Confirm", style: .default) { [ weak alertVC] _ in
            completion(alertVC?.textFields?[0].text, alertVC?.textFields?[1].text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(submitAction)
        alertVC.addAction(cancelAction)
        
        return alertVC
    }
}
