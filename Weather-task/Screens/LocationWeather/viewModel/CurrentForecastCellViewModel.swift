//
//  CurrentForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct CurrentForecastCellViewModel: AnyCollectionCellViewModel {
    let titleDescription: String
    let valueDescription: String
    
    func dequeue(collectionView: UICollectionView, for indexPath: IndexPath) -> AnyCollectionCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CurrentForecastCollectionCell.cellIdentifier, for: indexPath) as! CurrentForecastCollectionCell
    }
    
    
}
