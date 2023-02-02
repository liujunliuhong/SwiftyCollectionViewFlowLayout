//
//  TagListCell.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import UIKit

public final class TagListCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    public func bind(to model: TagListModel) {
        label.text = model.title
        label.textColor = model.textColor
        label.backgroundColor = model.backgroundColor
        label.font = model.font
    }
}
