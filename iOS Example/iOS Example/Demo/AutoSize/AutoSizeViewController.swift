//
//  AutoSizeViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/7.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

private let heights: [CGFloat] = [40, 50, 80, 110, 140]
private let widths: [CGFloat] = [40, 80, 110, 140, 150]
private let sectionTypes: [SwiftyCollectionViewSectionType] = [.waterFlow(numberOfColumns: 2),
                                                               .row(direction: .left, alignment: .top)]

/// 自动布局
public final class AutoSizeViewController: UIViewController {
    private var dataSource: [AutoSizeSectionModel] = []
    
    private lazy var layout: SwiftyCollectionViewFlowLayout = {
        let layout = SwiftyCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.register(DecorationView.classForCoder(), forDecorationViewOfKind: SwiftyCollectionViewFlowLayout.DecorationElementKind)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(AutoSizeCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(AutoSizeCell.classForCoder()))
        collectionView.register(AutoSizeHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(AutoSizeHeaderView.classForCoder()))
        collectionView.register(AutoSizeFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(AutoSizeFooterView.classForCoder()))
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        loadData()
    }
}

extension AutoSizeViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let itemTitles: [String] = [
            "dasda",
            "dasdasdasdas",
            "dasdasdasddsadsad", "dsadsadsadadsdadsa", "dasdasdasdsadasdasdasddasd",
            "dasdasdasdsadasdasdasddasddasdasdasdsadasdasdasddasddasdasdasdsadasdasdasddasddasdasdasdsadasdasdasddasd"
        ]
        let headerTitles: [String] = ["This is dynamic Header", "This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header", "This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header, This is dynamic Header"]
        let footerTitles: [String] = ["This is dynamic Footer", "This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer", "This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer, This is dynamic Footer"]
        
        let counts: [Int] = [15, 20, 25, 30]
        
        for _ in 0..<sectionTypes.count {
            var array: [AutoSizeItemModel] = []
            for _ in 0..<counts.randomElement()! {
                let width = widths.randomElement()!
                let height = heights.randomElement()!
                let model = AutoSizeItemModel(title: itemTitles.randomElement()!, width: width, height: height)
                array.append(model)
            }
            let sectionModel = AutoSizeSectionModel(headerTitle: headerTitles.randomElement()!, footerTitle: footerTitles.randomElement()!, items: array, sectionType: sectionTypes.randomElement()!)
            dataSource.append(sectionModel)
        }
        
        collectionView.reloadData()
    }
    
    @objc private func refreshAction() {
        //layout.scrollDirection = layout.scrollDirection == .vertical ? .horizontal : .vertical
        loadData()
    }
}

extension AutoSizeViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AutoSizeCell.classForCoder()), for: indexPath) as? AutoSizeCell else {
            return UICollectionViewCell()
        }
        let model = dataSource[indexPath.section].items[indexPath.item]
        cell.bind(to: model)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(AutoSizeHeaderView.classForCoder()), for: indexPath) as? AutoSizeHeaderView else {
                return UICollectionReusableView()
            }
            let model = dataSource[indexPath.section]
            headerView.bind(to: model)
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(AutoSizeFooterView.classForCoder()), for: indexPath) as? AutoSizeFooterView else {
                return UICollectionReusableView()
            }
            let model = dataSource[indexPath.section]
            footerView.bind(to: model)
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension AutoSizeViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        let model = dataSource[indexPath.section].items[indexPath.item]
        //return .init(width: .dynamic, height: .static(length: 30))
        return .init(width: .dynamic(increment: 15), height: .dynamic(increment: 15))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .fractionalFull(divisor: 3), height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .dynamic(), height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, headerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return .right
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, footerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return .right
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return dataSource[section].sectionType
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForDecorationInSection section: Int) -> SwiftyCollectionViewLayoutDecorationVisibilityMode {
        let extraAttributes = DecorationExtraAttributes()
        extraAttributes.cornerRadius = 10.0
        extraAttributes.backgroundColor = .purple
        return .visible(extraAttributes: extraAttributes)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, decorationExtraInset section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
