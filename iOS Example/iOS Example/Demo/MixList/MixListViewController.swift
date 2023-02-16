//
//  MixListViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/3.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

private let heights: [CGFloat] = [40, 50, 80, 110, 140]
private let widths: [CGFloat] = [40, 80, 110, 140, 150]
private let sectionTypes: [SwiftyCollectionViewSectionType] = [.waterFlow(numberOfColumns: 2),
                                                               .waterFlow(numberOfColumns: 3),
                                                               .waterFlow(numberOfColumns: 4),
                                                               .row(direction: .left, alignment: .top),
                                                               .row(direction: .left, alignment: .center),
                                                               .row(direction: .left, alignment: .bottom)
]

public final class MixListViewController: UIViewController {
    
    private var dataSource: [MixListSectionModel] = []
    
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
        //collectionView.contentInset = UIEdgeInsets(top: 40, left: 40, bottom: 140, right: 40)
        collectionView.register(MixListCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(MixListCell.classForCoder()))
        collectionView.register(MixListHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(MixListHeaderView.classForCoder()))
        collectionView.register(MixListFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(MixListFooterView.classForCoder()))
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
            make.bottom.equalToSuperview()//.offset(-80)
        }
        
        loadData()
    }
}

extension MixListViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let counts: [Int] = [10, 15, 20, 25, 30]
        
        for _ in 0...6 {
            var array: [MixListModel] = []
            for _ in 0..<counts.randomElement()! {
                let width = widths.randomElement()!
                let height = heights.randomElement()!
                let model = MixListModel(width: width, height: height)
                array.append(model)
            }
            let sectionModel = MixListSectionModel(sectionType: sectionTypes.randomElement()!, models: array)
            dataSource.append(sectionModel)
        }
        
        collectionView.reloadData()
    }
    
    @objc private func refreshAction() {
        loadData()
    }
}

extension MixListViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MixListCell.classForCoder()), for: indexPath) as? MixListCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(MixListHeaderView.classForCoder()), for: indexPath) as? MixListHeaderView else {
                return UICollectionReusableView()
            }
            let sectionType = dataSource[indexPath.section].sectionType
            switch sectionType {
                case .waterFlow(let numberOfColumns):
                    headerView.label.text = "Header\nSection-\(indexPath.section)\nSectionType:\nwaterFlow(numberOfColumns: \(numberOfColumns))"
                case .row(let direction, let alignment):
                    headerView.label.text = "Header\nSection-\(indexPath.section)\nSectionType:\ntagList(direction: \(direction), alignment: \(alignment))"
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(MixListFooterView.classForCoder()), for: indexPath) as? MixListFooterView else {
                return UICollectionReusableView()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension MixListViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return dataSource[section].sectionType
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForBackgroundInSection section: Int) -> SwiftyCollectionViewLayoutBackgroundVisibilityMode {
        return .hidden
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return .visible(sizeMode: .init(width: .full, height: .dynamic()))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        let model = dataSource[indexPath.section].models[indexPath.item]
        return .init(width: .absolute(model.width), height: .absolute(model.height))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return false
    }
}
