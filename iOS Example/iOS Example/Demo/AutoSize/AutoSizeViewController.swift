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
                                                               .tagList(direction: .left, alignment: .top)]

/// 自动布局，暂未完成
public final class AutoSizeViewController: UIViewController {
    
    private var dataSource: [AutoSizeSectionModel] = []
    
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
            make.bottom.equalToSuperview().offset(-80)
        }
        
        loadData()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.layout.invalidateLayout()
//        }
    }
}

extension AutoSizeViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let itemTitles: [String] = ["dasda", "dasdasdasdas", "dasdasdasddsadsad", "dsadsadsadadsdadsa", "dasdasdasdsadasdasdasddasd"]
        let headerTitles: [String] = ["This is Header", "This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header", "This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header, This is Header"]
        let footerTitles: [String] = ["This is Footer", "This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer", "This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer, This is Footer"]
        
        let counts: [Int] = [10, 15, 20, 25]
        
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

extension AutoSizeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.section].items[indexPath.item]
        // 当scrollDirection = .horizontal，高度无效
        // 当scrollDirection = .vertical，宽度无效
        return CGSize(width: model.width, height: model.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 当scrollDirection = .horizontal，高度无效
        // 当scrollDirection = .vertical，宽度无效
        return CGSize(width: 80, height: 80)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 当scrollDirection = .horizontal，高度无效
        // 当scrollDirection = .vertical，宽度无效
        return CGSize(width: 80, height: 80)
    }
}

extension AutoSizeViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return dataSource[section].sectionType
    }
}
