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
        collectionView.register(DecorationView.classForCoder(), forSupplementaryViewOfKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder())) // 注册背景视图
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
        } else if kind == SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind {
            guard let decorationView = collectionView.dequeueReusableSupplementaryView(ofKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder()), for: indexPath) as? DecorationView else {
                return UICollectionReusableView()
            }
            return decorationView
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .absolute(80), height: .absolute(80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .absolute(80), height: .absolute(80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        let model = dataSource[indexPath.section][indexPath.item]
        return .init(width: .absolute(model.width), height: .absolute(model.height))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForBackgroundInSection section: Int) -> SwiftyCollectionViewLayoutBackgroundVisibilityMode {
        return section == 1 ? .hidden : .visible
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, backgroundInset section: Int) -> UIEdgeInsets {
        return .zero
    }
}
