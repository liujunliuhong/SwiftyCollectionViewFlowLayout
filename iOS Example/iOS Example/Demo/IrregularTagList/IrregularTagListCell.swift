//
//  IrregularTagListCell.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/2.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

public final class IrregularTagListCell: SwiftyCollectionViewCell {
    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 193.0/255.0, alpha: 1)
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        return label
    }()
    
    var clickClosure: (() -> ())?
    
    private var model: IrregularTagListModel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        label.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        guard let model = model else { return }
        
//        model.height += 10
//        model.width += 10
//        
//        clickClosure?()
    }
    
    public func bind(to model: IrregularTagListModel) {
        self.model = model
        
        label.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
