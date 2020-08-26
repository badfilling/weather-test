//
//  RecentLocationsViewController.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class RecentLocationsViewController: UIViewController {
    let locationsTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(RecentLocationTableCell.self, forCellReuseIdentifier: RecentLocationTableCell.reuseIdentifier)
        return view
    }()
    
    let viewModel: RecentLocationsViewModel
    let cityProvider: CityProvider
    let disposeBag = DisposeBag()
    
    init(viewModel: RecentLocationsViewModel, cityProvider: CityProvider) {
        self.viewModel = viewModel
        self.cityProvider = cityProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupRxError()
        setupRxNavigation()
        setupTableRx()
    }
    
    func setupViews() {
        locationsTable.dataSource = self
        locationsTable.delegate = self
        view.backgroundColor = .white
        view.addSubview(locationsTable)
        locationsTable.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func setupTableRx() {
        viewModel.cellsToUpdateObservable
            .observeOn(MainScheduler.asyncInstance)
            .bind { [weak self] update in
                switch update {
                case .delete(let indexes):
                    self?.locationsTable.deleteRows(at: indexes, with: .fade)
                case .reload(let indexes):
                    self?.locationsTable.reloadRows(at: indexes, with: .automatic)
                case .insert(let indexes):
                    self?.locationsTable.insertRows(at: indexes, with: .automatic)
                }
        }.disposed(by: disposeBag)
    }
    
    func setupRxNavigation() {
        viewModel
            .nextScreenObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] screenType in
                var vc: UIViewController!
                switch screenType {
                case .locationWeather(let viewModel):
                    vc = LocationWeatherViewController(viewModel: viewModel)
                case .selectLocation(let viewModel):
                    vc = SelectLocationViewController(viewModel: viewModel)
                }
                self?.show(vc, sender: self)
            }).disposed(by: disposeBag)
        
    }
    
    func setupRxError() {
        viewModel.dataLoadingError
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Weather loading error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
    func setupNavigationBar() {
        title = "Choose a city"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocationClicked))
        navigationItem.leftBarButtonItem = addLocationButton
        let userLocationButton = UIBarButtonItem(image: UIImage(named: "userLocation"), style: .plain, target: self, action: #selector(addUserCoordinatesClicked))
        let customLocationButton = UIBarButtonItem(image: UIImage(named: "customLocation"), style: .plain, target: self, action: #selector(addCustomCoordinatesClicked))
        navigationItem.rightBarButtonItems = [userLocationButton, customLocationButton]
    }
    
    @objc func addUserCoordinatesClicked() {
        viewModel.addUserCoordinatesClicked()
    }
    
    @objc func addCustomCoordinatesClicked() {
        
    }
    
    @objc func addLocationClicked() {
        let cityDataSource = CityDataSourceImpl(cityProvider: cityProvider)
        let selectLocationVM = SelectLocationViewModel(dataSource: cityDataSource)
        selectLocationVM.addLocationDelegate = viewModel
        let citiesVC = SelectLocationViewController(viewModel: selectLocationVM)
        self.show(citiesVC, sender: self)
    }
}

extension RecentLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.getModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentLocationTableCell.reuseIdentifier) as! RecentLocationTableCell
        cell.setup(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectLocation(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteLocation(at: indexPath.row)
    }
}
