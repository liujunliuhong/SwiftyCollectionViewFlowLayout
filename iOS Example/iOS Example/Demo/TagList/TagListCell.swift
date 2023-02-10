//
//  TagListCell.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

public final class TagListCell: SwiftyCollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(to model: TagListModel) {
        label.text = model.title
        label.textColor = model.textColor
        label.backgroundColor = model.backgroundColor
        label.font = model.font
    }
}
