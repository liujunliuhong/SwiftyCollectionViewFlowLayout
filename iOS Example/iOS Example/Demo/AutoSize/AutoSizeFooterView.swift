//
//  AutoSizeFooterView.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/7.
//

import UIKit
import SnapKit
import SwiftyCollectionViewFlowLayout

public final class AutoSizeFooterView: SwiftyCollectionReusableView {
    
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
        label.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    public func bind(to model: AutoSizeSectionModel) {
        label.text = model.footerTitle
    }
}


