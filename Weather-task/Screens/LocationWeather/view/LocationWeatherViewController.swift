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
    
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .none
        return collection
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
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
//        title = "stub for weather"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isNavigationBarHidden = true
        setupViews()
        bindViewsRx()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
        }
        
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.distribution = .equalSpacing
        rowStack.addArrangedSubview(weatherIcon)
        rowStack.addArrangedSubview(temperatureLabel)
        view.addSubview(rowStack)
        
        rowStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(rowStack.snp.bottom).offset(16)
        }
    }
    
    func bindViewsRx() {
        viewModel.titleObservable
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.temperatureObservable
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherIconObservable
            .bind(to: weatherIcon.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.dataLoadingErrorObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] errorDescription in
                let alert = UIAlertController(title: "Weather loading error", message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

extension LocationWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.cellsData.keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0}
        return viewModel.cellsData[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section),
            let sectionData = viewModel.cellsData[section] else {
                return UICollectionViewCell()
        }
        let cellViewModel = sectionData[indexPath.row]
        let cell = cellViewModel.dequeue(collectionView: collectionView, for: indexPath)
        cell.setup(with: cellViewModel)
        return cell
//        return sectionData[indexPath.row].dequeue(collectionView: collectionView)
    }
    
    
}
