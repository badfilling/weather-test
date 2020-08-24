//
//  AnyCollectionCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
protocol AnyCollectionCellViewModel {
    func dequeue(collectionView: UICollectionView, for indexPath: IndexPath) -> AnyCollectionCell
}
