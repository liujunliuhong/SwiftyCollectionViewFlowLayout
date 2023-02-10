//
//  AutoSizeCell.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/7.
//

import UIKit
import SnapKit
import SwiftyCollectionViewFlowLayout

public final class AutoSizeCell: SwiftyCollectionViewCell {
    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 193.0/255.0, alpha: 1)
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(to model: AutoSizeItemModel) {
        label.text = model.title
    }
}

