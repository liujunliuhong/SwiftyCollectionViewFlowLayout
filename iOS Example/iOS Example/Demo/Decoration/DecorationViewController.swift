//
//  DecorationViewController.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/5.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

private let heights: [CGFloat] = [40, 50, 80, 110, 140]
private let widths: [CGFloat] = [40, 80, 110, 140, 150]

public final class DecorationViewController: UIViewController {
    
    private var dataSource: [[DecorationModel]] = []
    
    private lazy var layout: SwiftyCollectionViewFlowLayout = {
        let layout = SwiftyCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(DecorationCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(DecorationCell.classForCoder()))
        collectionView.register(DecorationHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(DecorationHeaderView.classForCoder()))
        collectionView.register(DecorationFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(DecorationFooterView.classForCoder()))
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalToSuperview().offset(120)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.layout.register(DecorationView.classForCoder(), forDecorationViewOfKind: NSStringFromClass(DecorationView.classForCoder())) // 注册装饰视图
            self.layout.invalidateLayout()
        }
    }
}

extension DecorationViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let counts: [Int] = [5, 10]
        for _ in 0...4 {
            var array: [DecorationModel] = []
            for _ in 0..<counts.randomElement()! {
                let width = widths.randomElement()!
                let height = heights.randomElement()!
                let model = DecorationModel(width: width, height: height)
                array.append(model)
            }
            dataSource.append(array)
        }
        
        collectionView.reloadData()
    }
}

extension DecorationViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(DecorationCell.classForCoder()), for: indexPath) as? DecorationCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(DecorationHeaderView.classForCoder()), for: indexPath) as? DecorationHeaderView else {
                return UICollectionReusableView()
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(DecorationFooterView.classForCoder()), for: indexPath) as? DecorationFooterView else {
                return UICollectionReusableView()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension DecorationViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .waterFlow(numberOfColumns: 5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        // 当scrollDirection = .horizontal，高度无效
        // 当scrollDirection = .vertical，宽度无效
        return .visible(sizeMode: .init(width: .static(length: 80), height: .static(length: 80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        // 当scrollDirection = .horizontal，高度无效
        // 当scrollDirection = .vertical，宽度无效
        return .visible(sizeMode: .init(width: .static(length: 80), height: .static(length: 80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewFlowLayoutSizeMode {
        let model = dataSource[indexPath.section][indexPath.item]
        return .init(width: .static(length: model.width), height: .static(length: model.height))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForDecorationInSection section: Int) -> SwiftyCollectionViewFlowLayoutDecorationVisibilityMode {
        if section != 1 {
            let extraAttributes = DecorationExtraAttributes()
            extraAttributes.cornerRadius = 10.0
            extraAttributes.backgroundColor = .purple
            
            return .visible(extraAttributes: extraAttributes)
        } else {
            return .hidden
        }
    }
}
