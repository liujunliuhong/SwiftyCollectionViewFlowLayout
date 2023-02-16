//
//  RowViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/13.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

/// 自动布局
public final class RowViewController: UIViewController {
    private var dataSource: [RowSectionModel] = []
    
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
        collectionView.register(RowCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(RowCell.classForCoder()))
        collectionView.register(RowHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(RowHeaderView.classForCoder()))
        collectionView.register(RowFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(RowFooterView.classForCoder()))
        collectionView.register(DecorationView.classForCoder(), forSupplementaryViewOfKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder())) // 注册背景视图
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        loadData()
    }
}

extension RowViewController {
    private func loadData() {
        dataSource.removeAll()
        
        var array: [RowItemModel] = []
        do {
            let itemModel = RowItemModel(width: .full, height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 2), height: .absolute(50))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 2), height: .absolute(60))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 3), height: .absolute(70))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 3), height: .absolute(80))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 3), height: .absolute(90))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 4), height: .absolute(100))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 4), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 4), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 4), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 5), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 5), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 5), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 5), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 5), height: .absolute(40))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 2), height: .fractionalFull(divisor: 3))
            array.append(itemModel)
        }
        do {
            let itemModel = RowItemModel(width: .fractionalFull(divisor: 2), height: .fractionalFull(divisor: 2))
            array.append(itemModel)
        }
        
        let sectionModel = RowSectionModel(items: array)
        dataSource.append(sectionModel)
        
        collectionView.reloadData()
    }
}

extension RowViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(RowCell.classForCoder()), for: indexPath) as? RowCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.item)"
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(RowHeaderView.classForCoder()), for: indexPath) as? RowHeaderView else {
                return UICollectionReusableView()
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(RowFooterView.classForCoder()), for: indexPath) as? RowFooterView else {
                return UICollectionReusableView()
            }
            return footerView
        } else if kind == SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind {
            guard let decorationView = collectionView.dequeueReusableSupplementaryView(ofKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder()), for: indexPath) as? DecorationView else {
                return UICollectionReusableView()
            }
            return decorationView
        }
        return UICollectionReusableView()
    }
}

extension RowViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        let model = dataSource[indexPath.section].items[indexPath.item]
        return .init(width: model.width, height: model.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, headerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return .left
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, footerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return .left
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .row(direction: .left, alignment: .center)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForBackgroundInSection section: Int) -> SwiftyCollectionViewLayoutBackgroundVisibilityMode {
        return .visible
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, backgroundInset section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
