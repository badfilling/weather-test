//
//  LocationWeatherViewController.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LocationWeatherViewController: UIViewController {
    let viewModel: LocationWeatherViewModel
    let sizingHeaderView = ForecastSectionHeaderView(frame: .zero)
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrentForecastTableCell.self, forCellReuseIdentifier: CurrentForecastTableCell.cellIdentifier)
        tableView.register(HourlyForecastTableCell.self, forCellReuseIdentifier: HourlyForecastTableCell.cellIdentifier)
        tableView.register(DailyForecastTableCell.self, forCellReuseIdentifier: DailyForecastTableCell.cellIdentifier)
        tableView.register(BasicWeatherDataCell.self, forCellReuseIdentifier: BasicWeatherDataCell.cellIdentifier)
        tableView.register(ForecastSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ForecastSectionHeaderView.viewReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(viewModel: LocationWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        setupViews()
        bindViewsRx()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func bindViewsRx() {
        viewModel.tableReloadObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] section in
                self?.tableView.reloadSections([section.rawValue], with: .automatic)
            }).disposed(by: disposeBag)
        
        viewModel.dataLoadingErrorObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] errorDescription in
                let alert = UIAlertController(title: "Weather loading error", message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

extension LocationWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cellsData.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherForecastSection(rawValue: section) else { return 0 }
        return viewModel.cellsData[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ForecastSectionHeaderView.viewReuseIdentifier) as! ForecastSectionHeaderView
        view.titleLabel.text = WeatherForecastSection(rawValue: section)?.description
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        sizingHeaderView.titleLabel.text = "z"
        return sizingHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherForecastSection(rawValue: indexPath.section),
            let sectionData = viewModel.cellsData[section] else {
                return UITableViewCell()
        }
        let cellViewModel = sectionData[indexPath.row]
        let cell = cellViewModel.dequeue(tableView: tableView, for: indexPath)
        cell.setup(with: cellViewModel)
        return cell
    }
}

extension LocationWeatherViewController {
    static var primaryBackgroundColor: UIColor {
        return UIColor(red: 232.0/255.0, green: 244.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    }
}
