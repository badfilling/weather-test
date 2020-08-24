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
        DispatchQueue.main.async {
            self.setupTableRx()
        }
        viewModel.onLocationAdd = { [weak self] indexPath in
            self?.locationsTable.insertRows(at: [indexPath], with: .automatic)
        }
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
        viewModel.cellsToInsert
            .observeOn(MainScheduler.asyncInstance)
            .bind { [weak self] indexes in
                if indexes.isEmpty { return }
                
                self?.locationsTable.insertRows(at: indexes, with: .automatic)
        }.disposed(by: disposeBag)
        
        viewModel.cellsToReload
            .observeOn(MainScheduler.asyncInstance)
            .bind { [weak self] indexes in
                if indexes.isEmpty { return }
                
                self?.locationsTable.reloadRows(at: indexes, with: .automatic)
        }.disposed(by: disposeBag)
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
    }
    
    @objc func addLocationClicked() {
        let cityDataSource = CityDataSourceImpl(cityProvider: cityProvider)
        let selectLocationVM = SelectLocationViewModelImpl(dataSource: cityDataSource)
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
        print("dequeue is called")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVM = LocationWeatherViewModel(location: viewModel.locationModels[indexPath.row], weatherProvider: viewModel.weatherProvider, weatherIconProvider: viewModel.iconProvider)
        let detailsVC = LocationWeatherViewController(viewModel: detailsVM)
        show(detailsVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteLocation(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
