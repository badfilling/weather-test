//
//  RecentLocationsViewModelTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import Weather_task
class RecentLocationsViewModelTests: XCTestCase {

    var viewModel: RecentLocationsViewModel!
    var recentCitiesProvider: RecentlyViewedCitiesProviderMock!
    var weatherProvider: WeatherAPIClientMock!
    var iconProvider: WeatherIconProviderMock!
    var locationService: LocationServiceMock!
    var cityProvider: CityProviderMock!
    var disposeBag: DisposeBag!
    override func setUpWithError() throws {
        recentCitiesProvider = RecentlyViewedCitiesProviderMock()
        weatherProvider = WeatherAPIClientMock()
        iconProvider = WeatherIconProviderMock()
        locationService = LocationServiceMock()
        cityProvider = CityProviderMock()
        disposeBag = DisposeBag()
        viewModel = RecentLocationsViewModel(recentCitiesProvider: recentCitiesProvider, weatherProvider: weatherProvider, iconProvider: iconProvider, locationService: locationService, cityProvider: cityProvider)
    }
    
    func testRecentCitiesLoadedOnceOnInit() {
        viewModel = RecentLocationsViewModel(recentCitiesProvider: recentCitiesProvider, weatherProvider: weatherProvider, iconProvider: iconProvider, locationService: locationService, cityProvider: cityProvider)
        
        let exp = expectation(description: "loaded cities once")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.15)
    }
    
    func testRecentCitiesLoadSendsInsertEvent() {
        let locations = [prepareLocation(), prepareLocation()]
        let exp = expectation(description: "inserted cells event registered")
        recentCitiesProvider.storedCities = locations
        viewModel = RecentLocationsViewModel(recentCitiesProvider: recentCitiesProvider, weatherProvider: weatherProvider, iconProvider: iconProvider, locationService: locationService, cityProvider: cityProvider)
        
        viewModel.cellsToUpdateObservable
            .subscribe(onNext: { update in
                switch update {
                case .insert(let indexes):
                    if indexes.count == locations.count {
                        exp.fulfill()
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)
        wait(for: [exp], timeout: 0.2)
    }
    
    func testLocationStoredOnBeingAdded() {
        let location = prepareLocation()
        
        viewModel.added(location: location)
        
        XCTAssertEqual(recentCitiesProvider.storeCalledtimes, 1)
    }
    
    func testLocationInsertedToTableWhenAdded() {
        let exp = expectation(description: "location added to table")
        
        viewModel.cellsToUpdateObservable
        .skip(1)
        .subscribe(onNext: { update in
            switch update {
            case .insert(_):
                exp.fulfill()
            default:
                break
            }
            }).disposed(by: disposeBag)
        
        viewModel.added(location: prepareLocation())
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testDeleteLocationRemovesFromRecent() {
        viewModel.added(location: prepareLocation())
        
        viewModel.deleteLocation(at: 0)
        
        XCTAssertEqual(recentCitiesProvider.removeCalledTimes, 1)
    }
    
    func testWeatherLoadedOnLocationAddIfCurrentIsNil() {
        weatherProvider.currentWeatherLoadedtimes = 0
        viewModel.added(location: prepareLocation())
        
        XCTAssertEqual(weatherProvider.currentWeatherLoadedtimes, 1)
    }
    
    func testWeatherLoadedOnLocationAddIfCurrentIsOld() {
        weatherProvider.currentWeatherLoadedtimes = 0
        viewModel.added(location: prepareLocation(forecastTimestamp: Date().addingTimeInterval(-1000).timeIntervalSince1970, currentWeather: prepareCurrentWeather()))
        
        XCTAssertEqual(weatherProvider.currentWeatherLoadedtimes, 1)
    }
    
    func testCellReloadEventReceivedOnWeatherLoaded() {
        let location = prepareLocation(currentWeather: prepareCurrentWeather())
        weatherProvider.currentWeatherToReturn = location
        let exp = expectation(description: "reload cell event received")
        
        viewModel.added(location: location)
        
        viewModel.cellsToUpdateObservable
        .subscribe(onNext: { update in
            switch update {
            case .reload(_):
                exp.fulfill()
            default:
                break
            }
            }).disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func prepareLocation(uuid: UUID = UUID(), forecastTimestamp: Double? = nil, currentWeather: CurrentWeather? = nil) -> LocationWeatherData {
        return LocationWeatherData(uuid: uuid, cityId: nil, cityName: nil, cityCoordinates: Coordinates(latitude: 0, longitude: 0), countryCode: nil, currentWeather: currentWeather, forecastTimestamp: forecastTimestamp)
    }
    
    func prepareCurrentWeather() -> CurrentWeather {
        return CurrentWeather(temperature: 0, temperatureFeelsLike: 0, pressure: 0, humidity: 0, windSpeed: 0, cloudsPercent: 0, weatherConditionDescription: "", weatherConditionIconName: "", timezoneOffset: 0, cityName: "")
    }
}
