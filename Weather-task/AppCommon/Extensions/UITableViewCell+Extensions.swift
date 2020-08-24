//
//  UITableViewCell+Extensions.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
