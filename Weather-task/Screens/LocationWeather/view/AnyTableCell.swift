//
//  AnyTableCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
protocol AnyTableCell: UITableViewCell {
    static var cellIdentifier: String { get }
    func setup(with model: AnyTableCellViewModel)
}
extension AnyTableCell {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
