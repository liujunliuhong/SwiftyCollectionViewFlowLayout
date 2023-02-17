//
//  PinnedHeaderOrFooterViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/14.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

/// PinnedHeaderOrFooter
public final class PinnedHeaderOrFooterViewController: UIViewController {
    
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
        collectionView.register(PinnedHeaderOrFooterCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterCell.classForCoder()))
        collectionView.register(PinnedHeaderOrFooterHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterHeaderView.classForCoder()))
        collectionView.register(PinnedHeaderOrFooterFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterFooterView.classForCoder()))
        collectionView.register(DecorationView.classForCoder(), forSupplementaryViewOfKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder())) // 注册背景视图
        collectionView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
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
    }
}

extension PinnedHeaderOrFooterViewController {
    
}

extension PinnedHeaderOrFooterViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterCell.classForCoder()), for: indexPath) as? PinnedHeaderOrFooterCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterHeaderView.classForCoder()), for: indexPath) as? PinnedHeaderOrFooterHeaderView else {
                return UICollectionReusableView()
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(PinnedHeaderOrFooterFooterView.classForCoder()), for: indexPath) as? PinnedHeaderOrFooterFooterView else {
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

extension PinnedHeaderOrFooterViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        return .init(width: .fractionalFull(divisor: 3), height: .absolute(45))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .absolute(60)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .absolute(60)))
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, headerPinToVisibleBounds section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, footerPinToVisibleBounds section: Int) -> Bool {
        return true
    }
}
