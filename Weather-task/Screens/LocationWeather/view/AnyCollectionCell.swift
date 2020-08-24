//
//  AnyCollectionCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
protocol AnyCollectionCell: UICollectionViewCell {
    static var cellIdentifier: String { get }
    func setup(with model: AnyCollectionCellViewModel)
}
extension AnyCollectionCell {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
