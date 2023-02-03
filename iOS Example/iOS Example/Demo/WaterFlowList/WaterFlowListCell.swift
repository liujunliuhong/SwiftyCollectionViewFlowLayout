//
//  WaterFlowListCell.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/3.
//

import UIKit

public final class WaterFlowListCell: UICollectionViewCell {
    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 193.0/255.0, alpha: 1)
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
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
}

