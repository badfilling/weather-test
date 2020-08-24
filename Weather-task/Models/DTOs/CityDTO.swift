//
//  CityDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import CoreLocation

struct CityDTO: Codable {
    let id: Int
    let name: String
    let countryCode: String?
    let coordinates: Coordinates
    
    var descrtiption: String {
        return "\(name.appending(countryCode == nil ? "" : ", \(countryCode!)"))"
    }
}

extension CityDTO {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countryCode = "country"
        case coordinates = "coord"
    }
}

extension CityDTO: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
