//
//  SelectLocationViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import UIKit
import RxRelay

protocol SelectLocationViewModel {
    func searchTextProvided(query: String)
    func didSelectCity(at indexPath: IndexPath)
    var cellModels: BehaviorRelay<[SelectLocationCellViewModel]> { get }
}

class SelectLocationViewModelImpl: SelectLocationViewModel {
    let cellModels: BehaviorRelay<[SelectLocationCellViewModel]>
    private let dataSource: CityDataSource
    private var lastSearchQuery: String?
    private var cities = [CityDTO]()
    weak var addLocationDelegate: AddLocationDelegate?
    
    init(dataSource: CityDataSource) {
        self.dataSource = dataSource
        cellModels = BehaviorRelay(value: [])
    }
    
    func searchTextProvided(query: String) {
        dataSource.getCities(query: query) { [weak self] result in
            switch result {
            case .success(let cities):
                var cellModels = [SelectLocationCellViewModel]()
                let foldedQuery = query.prepareForSearch()
                for city in cities {
                    let attributedString = NSMutableAttributedString(string: city.descrtiption)
                    let boldAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: SelectLocationCellViewModel.fontSize)]
                    let range = (city.descrtiption.prepareForSearch() as NSString).range(of: foldedQuery)
                    attributedString.addAttributes(boldAttribute, range: range)
                    
                    cellModels.append(SelectLocationCellViewModel(title: attributedString))
                }
                self?.cellModels.accept(cellModels)
                self?.cities = cities
            case .failure(_):
                break
            }
            
        }
    }
    
    func didSelectCity(at indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let location = LocationWeatherData(cityId: city.id, cityName: city.name, cityCoordinates: city.coordinates, countryCode: city.countryCode, currentWeather: nil)
        addLocationDelegate?.added(location: location)
    }
}
