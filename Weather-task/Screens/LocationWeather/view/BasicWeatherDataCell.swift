//
//  BasicWeatherDataCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
class BasicWeatherDataCell: UITableViewCell, AnyTableCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.distribution = .equalSpacing
        rowStack.addArrangedSubview(weatherIcon)
        rowStack.addArrangedSubview(temperatureLabel)
        contentView.addSubview(rowStack)
        
        rowStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        weatherIcon.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
    }
    
    func setup(with model: AnyTableCellViewModel) {
        guard let model = model as? BasicWeatherCellViewModel else { return }
        titleLabel.text = model.titleDescription
        temperatureLabel.text = model.temperatureDescription
        temperatureLabel.textColor = model.temperatureLabelColor
        _ = model.setImage(for: weatherIcon)
    }
}
