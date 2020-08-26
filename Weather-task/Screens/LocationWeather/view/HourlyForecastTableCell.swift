//
//  HourlyForecastTableCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import SnapKit

class HourlyForecastTableCell: UITableViewCell, AnyTableCell {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    var onReuse: (() -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse?()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalToSuperview().offset(102)
        }
        
        contentView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
        }
    }
    
    func setup(with model: AnyTableCellViewModel) {
        guard let model = model as? HourlyForecastCellViewModel else { return }
        timeLabel.text = model.dateDescription
        temperatureLabel.text = model.temperatureDescription
        onReuse = model.setImage(for: weatherIcon)
    }
}
