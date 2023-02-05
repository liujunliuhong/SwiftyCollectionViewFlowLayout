//
//  DecorationHeaderView.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/5.
//

import UIKit

public final class DecorationHeaderView: UICollectionReusableView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
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
        label.text = "Header\nSection-\(layoutAttributes.indexPath.section)"
    }
}
