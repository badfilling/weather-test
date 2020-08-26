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
import RxSwift

class SelectLocationViewModel {
    lazy var cellModelsObservable: Observable<[SelectLocationCellViewModel]> = {
        return cellModelsRelay.asObservable()
    }()
    private let cellModelsRelay: BehaviorRelay<[SelectLocationCellViewModel]>
    private let dataSource: CityDataSource
    private let coordinatesInputValidator: LocationInputValidator
    private var lastSearchQuery: String?
    private var cities = [CityDTO]()
    weak var addLocationDelegate: AddLocationDelegate?
    
    init(dataSource: CityDataSource, coordinatesInputValidator: LocationInputValidator) {
        self.dataSource = dataSource
        self.coordinatesInputValidator = coordinatesInputValidator
        cellModelsRelay = BehaviorRelay(value: [])
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
                self?.cellModelsRelay.accept(cellModels)
                self?.cities = cities
            case .failure(_):
                break
            }
            
        }
    }
    
    func didSelectCity(at indexPath: IndexPath) {
        guard let city = cities[safeIndex: indexPath.row] else { return }
        let location = LocationWeatherData(uuid: UUID(), cityId: city.id, cityName: city.name, cityCoordinates: city.coordinates, countryCode: city.countryCode, currentWeather: nil)
        addLocationDelegate?.added(location: location)
    }
    
    func addUserCoordinatesClicked() {
        addLocationDelegate?.addedUserLocation()
    }
    
    func customCoordinatesProvided(latitudeText: String?, longitudeText: String?) -> Single<Any> {
        return Single<Any>.create { [weak self] single in
            
            do {
                if let coordinates = try self?.coordinatesInputValidator.convertToCoordinates(latitudeText: latitudeText, longitudeText: longitudeText) {
                    self?.addLocationDelegate?.added(coordinates: coordinates)
                    single(.success(()))
                }
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
