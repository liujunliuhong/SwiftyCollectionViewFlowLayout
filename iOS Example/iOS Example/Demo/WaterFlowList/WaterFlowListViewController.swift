//
//  WaterFlowListViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/3.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

private let heights: [CGFloat] = [40, 50, 80, 110, 140]
private let widths: [CGFloat] = [40, 80, 110, 140, 150]


public final class WaterFlowListViewController: UIViewController {
    
    private var dataSource: [[WaterFlowModel]] = []
    
    private var sectionInsetContainHeader: Bool = false {
        didSet {
            updateUI()
        }
    }
    private var sectionInsetContainFooter: Bool = false {
        didSet {
            updateUI()
        }
    }
    private var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            updateUI()
        }
    }
    
    private lazy var layout: SwiftyCollectionViewFlowLayout = {
        let layout = SwiftyCollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        return layout
    }()
    
    private lazy var scrollDirectionButton: UIButton = {
        let scrollDirectionButton = UIButton(type: .system)
        scrollDirectionButton.titleLabel?.numberOfLines = 0
        scrollDirectionButton.contentHorizontalAlignment = .center
        scrollDirectionButton.addTarget(self, action: #selector(scrollDirectionAction), for: .touchUpInside)
        return scrollDirectionButton
    }()
    
    private lazy var sectionInsetContainHeaderButton: UIButton = {
        let sectionInsetContainHeaderButton = UIButton(type: .system)
        sectionInsetContainHeaderButton.titleLabel?.numberOfLines = 0
        sectionInsetContainHeaderButton.contentHorizontalAlignment = .center
        sectionInsetContainHeaderButton.addTarget(self, action: #selector(sectionInsetContainHeaderAction), for: .touchUpInside)
        return sectionInsetContainHeaderButton
    }()
    
    private lazy var sectionInsetContainFooterButton: UIButton = {
        let sectionInsetContainFooterButton = UIButton(type: .system)
        sectionInsetContainFooterButton.titleLabel?.numberOfLines = 0
        sectionInsetContainFooterButton.contentHorizontalAlignment = .center
        sectionInsetContainFooterButton.addTarget(self, action: #selector(sectionInsetContainFooterAction), for: .touchUpInside)
        return sectionInsetContainFooterButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(WaterFlowListCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(WaterFlowListCell.classForCoder()))
        collectionView.register(WaterFlowListHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(WaterFlowListHeaderView.classForCoder()))
        collectionView.register(WaterFlowListFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(WaterFlowListFooterView.classForCoder()))
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollDirectionButton)
        view.addSubview(sectionInsetContainHeaderButton)
        view.addSubview(sectionInsetContainFooterButton)
        view.addSubview(collectionView)
        
        
        scrollDirectionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(120)
            make.height.equalTo(30)
        }
        sectionInsetContainHeaderButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(scrollDirectionButton.snp.bottom).offset(15)
            make.height.equalTo(scrollDirectionButton)
        }
        sectionInsetContainFooterButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(sectionInsetContainHeaderButton.snp.bottom).offset(15)
            make.height.equalTo(scrollDirectionButton)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalTo(sectionInsetContainFooterButton.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        updateUI()
        
        loadData()
    }
}

extension WaterFlowListViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let counts: [Int] = [10, 15, 20, 25, 30]
        for _ in 0...4 {
            var array: [WaterFlowModel] = []
            for _ in 0..<counts.randomElement()! {
                let width = widths.randomElement()!
                let height = heights.randomElement()!
                let model = WaterFlowModel(width: width, height: height)
                array.append(model)
            }
            dataSource.append(array)
        }
        
        collectionView.reloadData()
    }
    
    @objc private func sectionInsetContainHeaderAction() {
        sectionInsetContainHeader = !sectionInsetContainHeader
        collectionView.reloadData()
    }
    
    @objc private func sectionInsetContainFooterAction() {
        sectionInsetContainFooter = !sectionInsetContainFooter
        collectionView.reloadData()
    }
    
    @objc private func scrollDirectionAction() {
        if scrollDirection == .vertical {
            layout.scrollDirection = .horizontal
        } else if scrollDirection == .horizontal {
            layout.scrollDirection = .vertical
        }
        scrollDirection = layout.scrollDirection
        
        collectionView.reloadData()
    }
    
    private func updateUI() {
        sectionInsetContainHeaderButton.setTitle("sectionInsetContainHeader: \(sectionInsetContainHeader ? "YES": "NO")", for: .normal)
        sectionInsetContainFooterButton.setTitle("sectionInsetContainFooter: \(sectionInsetContainFooter ? "YES": "NO")", for: .normal)
        
        if scrollDirection == .vertical {
            scrollDirectionButton.setTitle("滑动方向: 垂直", for: .normal)
        } else if scrollDirection == .horizontal {
            scrollDirectionButton.setTitle("滑动方向: 水平", for: .normal)
        }
    }
}

extension WaterFlowListViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(WaterFlowListCell.classForCoder()), for: indexPath) as? WaterFlowListCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(WaterFlowListHeaderView.classForCoder()), for: indexPath) as? WaterFlowListHeaderView else {
                return UICollectionReusableView()
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(WaterFlowListFooterView.classForCoder()), for: indexPath) as? WaterFlowListFooterView else {
                return UICollectionReusableView()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}


extension WaterFlowListViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        let model = dataSource[indexPath.section][indexPath.item]
        return .init(width: .static(length: model.width), height: .static(length: model.height))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .static(length: 80), height: .static(length: 80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .static(length: 80), height: .static(length: 80)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return sectionInsetContainHeader
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return sectionInsetContainFooter
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .waterFlow(numberOfColumns: 3)
    }
}
