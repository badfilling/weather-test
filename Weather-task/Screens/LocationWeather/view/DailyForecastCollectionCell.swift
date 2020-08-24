//
//  DailyForecastCollectionCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class DailyForecastCollectionCell: UICollectionViewCell, AnyCollectionCell {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    var onReuse: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse?()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func setupViews() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(timeLabel.snp.trailing).offset(24)
            make.centerY.equalToSuperview()
        }
        
        let temperatureStack = UIStackView()
        temperatureStack.axis = .vertical
        temperatureStack.distribution = .fillEqually
        temperatureStack.addArrangedSubview(maxTemperatureLabel)
        temperatureStack.addArrangedSubview(minTemperatureLabel)
        contentView.addSubview(temperatureStack)
        temperatureStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    func setup(with model: AnyCollectionCellViewModel) {
        guard let model = model as? DailyForecastCellViewModel else { return }
        timeLabel.text = model.dateDescription
        minTemperatureLabel.text = model.minTemperatureDescription
        maxTemperatureLabel.text = model.maxTemperatureDescription
        onReuse = model.setImage(for: weatherIcon)
    }
}
