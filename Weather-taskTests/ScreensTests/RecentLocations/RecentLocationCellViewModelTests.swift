//
//  RecentLocationCellViewModelTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task

class RecentLocationCellViewModelTests: XCTestCase {

    var viewModel: RecentLocationCellViewModel!
    var imageLoader: WeatherIconProviderMock!
    override func setUpWithError() throws {
        imageLoader = WeatherIconProviderMock()
        viewModel = RecentLocationCellViewModel(from: prepareLocation(iconName: ""), imageLoader: imageLoader)

    }
    
    func testImageLoaderCalledForCorrectIconName() {
        let iconName = "someIcon"
        
        let location = prepareLocation(iconName: iconName)
        viewModel = RecentLocationCellViewModel(from: location, imageLoader: imageLoader)
        
        let imageView = UIImageView()
        _ = viewModel.setImage(for: imageView)
        
        XCTAssertNotNil(imageLoader.calledForIcon)
        XCTAssertEqual(iconName, imageLoader.calledForIcon)
    }
    
    func testImageViewImageIsSet() {
        let image = UIImage(named: "testIcon.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageData = image?.pngData()
        imageLoader.dataToReturn = imageData
        let exp = expectation(description: "image is set")
        
        let imageView = UIImageView()
        _ = viewModel.setImage(for: imageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            if let imageViewRaw = imageView.image?.pngData(),
                let templateRaw = imageData {
                if (imageViewRaw as NSData).isEqual(to: templateRaw) {
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 0.3)
    }

    func prepareLocation(iconName: String) -> LocationWeatherData {
        return LocationWeatherData(uuid: UUID(), cityId: nil, cityName: nil, cityCoordinates: Coordinates(latitude: 0, longitude: 0), countryCode: nil, currentWeather: CurrentWeather(temperature: 0, temperatureFeelsLike: 0, pressure: 0, humidity: 0, windSpeed: 0, cloudsPercent: 0, weatherConditionDescription: nil, weatherConditionIconName: iconName, timezoneOffset: 0, cityName: nil), forecastTimestamp: nil)
    }
}
