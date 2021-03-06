//
//  SelectLocationViewController.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class SelectLocationViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.autocorrectionType = .no
        bar.placeholder = "Enter city name"
        bar.delegate = self
        return bar
    }()
    
    let citiesTable = UITableView(frame: .zero, style: .plain)
    let viewModel: SelectLocationViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: SelectLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Add a city"
        view.backgroundColor = .white
        setupViews()
        setupNavigationBar()
        //because of rxCocoa/uikit bug - delay binding rx data source a bit
        DispatchQueue.main.async {
            self.setupTableRx()
        }
        setupSearchBarRx()
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(citiesTable)
        citiesTable.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(8)
        }
        
        citiesTable.keyboardDismissMode = .onDrag
    }
    
    func setupNavigationBar() {
        let userLocationButton = UIBarButtonItem(image: UIImage(named: "userLocation"), style: .plain, target: self, action: #selector(addUserCoordinatesClicked))
        let customLocationButton = UIBarButtonItem(image: UIImage(named: "customLocation"), style: .plain, target: self, action: #selector(addCustomCoordinatesClicked))
        navigationItem.rightBarButtonItems = [userLocationButton, customLocationButton]
    }
    
    @objc func addUserCoordinatesClicked() {
        viewModel.addUserCoordinatesClicked()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addCustomCoordinatesClicked() {
        let alertVC = UIAlertController.createCoordinateInput { [weak self] (latitude, longitude) in
            guard let `self` = self else { return }
            self.viewModel.customCoordinatesProvided(latitudeText: latitude, longitudeText: longitude)
                .subscribe { [weak self] event in
                    switch event {
                    case .error(let error):
                        let alert = UIAlertController(title: "Getting weather at location", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    case .success(_):
                        self?.navigationController?.popViewController(animated: true)
                    }
            }.disposed(by: self.disposeBag)
        }
        present(alertVC, animated: true)
    }
    
    func setupTableRx() {
        citiesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cityListCell")
        viewModel.cellModelsObservable
            .bind(to: citiesTable.rx.items(cellIdentifier: "cityListCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.attributedText = element.title
        }.disposed(by: disposeBag)
        
        citiesTable.rx.itemSelected
            .subscribe(onNext: {[weak self] indexPath in
                guard let `self` = self else { return }
                self.viewModel.didSelectCity(at: indexPath)
                //TODO: if coordinator -remove dismiss
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupSearchBarRx() {
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(150), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.searchTextProvided(query: text)
                
            }).disposed(by: disposeBag)
    }
}

extension SelectLocationViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
