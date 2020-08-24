//
//  SelectLocationCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct SelectLocationCellViewModel {
    let title: NSAttributedString
}

extension SelectLocationCellViewModel {
    static var fontSize: CGFloat {
        return UIFont.preferredFont(forTextStyle: .body).pointSize
    }
}
