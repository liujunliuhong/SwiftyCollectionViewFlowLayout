//
//  IrregularTagListFooterView.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/2.
//

import UIKit

public final class IrregularTagListFooterView: UICollectionReusableView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        label.text = "Footer\nSection-\(layoutAttributes.indexPath.section)"
    }
}
