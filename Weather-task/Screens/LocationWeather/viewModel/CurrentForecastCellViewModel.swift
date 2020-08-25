//
//  CurrentForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct CurrentForecastCellViewModel: AnyTableCellViewModel {
    let titleDescription: String
    let valueDescription: String
    
    func dequeue(tableView: UITableView, for indexPath: IndexPath) -> AnyTableCell {
        return tableView.dequeueReusableCell(withIdentifier: CurrentForecastTableCell.cellIdentifier, for: indexPath) as! CurrentForecastTableCell
    }
}
