//
//  SelectLocationViewModelTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
import UIKit
import RxSwift
@testable import Weather_task
class SelectLocationViewModelTests: XCTestCase {

    var viewModel: SelectLocationViewModel!
    var dataSource: CityDataSourceMock!
    var disposeBag: DisposeBag!
    var inputValidator: LocationInputValidatorMock!
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        dataSource = CityDataSourceMock()
        inputValidator = LocationInputValidatorMock()
        viewModel = SelectLocationViewModel(dataSource: dataSource, coordinatesInputValidator: inputValidator)
    }
    
    func testDataSourceCalledWhenQueryProvided() {
        viewModel.searchTextProvided(query: "")
        
        XCTAssertEqual(dataSource.calledTimes, 1)
    }
    
    func testCellModelsUpdatedWhenCitiesProvided() {
        let cities = [prepareCity()]
        dataSource.cities = cities
        
        let exp = expectation(description: "cells updated")
        
        viewModel.cellModelsObservable
            .skip(1)
            .subscribe(onNext: { _ in
                exp.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel.searchTextProvided(query: "")
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testAddLocationDelegateCalled() {
        let cities = [prepareCity()]
        dataSource.cities = cities
        
        let exp = expectation(description: "add location delegate called")
        let delegate = LocationDelegateMock()
        viewModel.addLocationDelegate = delegate
        viewModel.searchTextProvided(query: "")
        
        viewModel.didSelectCity(at: IndexPath(row: 0, section: 0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if delegate.calledTimes == 1 {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func prepareCity() -> CityDTO {
        return CityDTO(id: 0, name: "", countryCode: nil, coordinates: Coordinates(latitude: 0, longitude: 0))
    }
}
