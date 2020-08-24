//
//  CurrentForecastCollectionCell.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class CurrentForecastCollectionCell: UICollectionViewCell, AnyCollectionCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.top.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
        }
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func setup(with model: AnyCollectionCellViewModel) {
        guard let model = model as? CurrentForecastCellViewModel else { return }
        titleLabel.text = model.titleDescription
        valueLabel.text = model.valueDescription
    }
}
