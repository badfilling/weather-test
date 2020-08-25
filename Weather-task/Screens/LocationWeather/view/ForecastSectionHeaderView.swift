//
//  ForecastSectionHeaderView.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class ForecastSectionHeaderView: UITableViewHeaderFooterView {
    static var viewReuseIdentifier: String {
        return String(describing: self)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let bgView = UIView()
        bgView.backgroundColor = LocationWeatherViewController.primaryBackgroundColor
        self.backgroundView = bgView
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16).priority(999)
            make.trailing.equalToSuperview().priority(999)
            make.top.equalToSuperview().offset(8).priority(999)
            make.bottom.equalToSuperview().offset(-20).priority(999)
        }
    }
}
