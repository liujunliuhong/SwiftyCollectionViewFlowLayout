//
//  MixListFooterView.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/3.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

public final class MixListFooterView: SwiftyCollectionReusableView {
    
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
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        label.text = "Footer\nSection-\(layoutAttributes.indexPath.section)"
    }
}
