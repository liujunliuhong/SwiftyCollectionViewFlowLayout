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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.layout.register(DecorationView.classForCoder(), forDecorationViewOfKind: NSStringFromClass(DecorationView.classForCoder())) // 注册装饰视图
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

extension DecorationViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.section][indexPath.item]
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

extension DecorationViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .waterFlow(numberOfColumns: 7)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, decorationViewDisplay section: Int) -> Bool {
        return section != 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, decorationExtraAttributes section: Int) -> SwiftyCollectionViewLayoutDecorationExtraAttributes? {
        let extraAttributes = DecorationExtraAttributes()
        extraAttributes.cornerRadius = 10.0
        extraAttributes.backgroundColor = .purple
        return extraAttributes
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, decorationExtraInset section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return true
    }
}
