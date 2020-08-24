//
//  HourlyForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class HourlyForecastCellViewModel: AnyCellViewModel {
    
    func dequeue(collectionView: UICollectionView, for indexPath: IndexPath) -> AnyCellType {
        return collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionCell.cellIdentifier, for: indexPath) as! HourlyForecastCollectionCell
    }
}
