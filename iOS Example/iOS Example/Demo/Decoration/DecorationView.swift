//
//  DecorationView.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/5.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

public final class DecorationView: SwiftyCollectionReusableView {
    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 60)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "装饰视图"
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(label)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let layoutAttributes = layoutAttributes as? SwiftyCollectionViewLayoutDecorationAttributes else {
            return
        }
        guard let extraAttributes = layoutAttributes.extraAttributes as? DecorationExtraAttributes else {
            return
        }
        bgView.layer.cornerRadius = extraAttributes.cornerRadius
        bgView.backgroundColor = extraAttributes.backgroundColor
    }
}
