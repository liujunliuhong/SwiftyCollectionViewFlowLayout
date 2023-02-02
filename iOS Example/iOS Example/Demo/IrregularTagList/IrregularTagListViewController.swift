//
//  IrregularTagListViewController.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/2.
//

import UIKit
import SwiftyCollectionViewFlowLayout
import SnapKit

private let heights: [CGFloat] = [20, 40, 60, 80, 100, 120]
private let widths: [CGFloat] = [40, 60, 80, 100, 120, 140]


public final class IrregularTagListViewController: UIViewController {
    
    private var dataSource: [[IrregularTagListModel]] = []
    
    private var direction: SwiftyCollectionViewDirection = .left {
        didSet {
            updateUI()
        }
    }
    private var alignment: SwiftyCollectionViewAlignment = .top {
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
    
    private lazy var directionButton: UIButton = {
        let directionButton = UIButton(type: .system)
        directionButton.addTarget(self, action: #selector(directionAction), for: .touchUpInside)
        return directionButton
    }()
    
    private lazy var scrollDirectionButton: UIButton = {
        let scrollDirectionButton = UIButton(type: .system)
        scrollDirectionButton.addTarget(self, action: #selector(scrollDirectionAction), for: .touchUpInside)
        return scrollDirectionButton
    }()
    
    private lazy var alignmentButton: UIButton = {
        let alignmentButton = UIButton(type: .system)
        alignmentButton.addTarget(self, action: #selector(alignmentAction), for: .touchUpInside)
        return alignmentButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TagListCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TagListCell.classForCoder()))
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "不规则标签列表"
        
        view.addSubview(scrollDirectionButton)
        view.addSubview(directionButton)
        view.addSubview(alignmentButton)
        view.addSubview(collectionView)
        
        
        scrollDirectionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(120)
            make.height.equalTo(45)
        }
        directionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.height.equalTo(scrollDirectionButton)
        }
        alignmentButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.height.equalTo(scrollDirectionButton)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalTo(scrollDirectionButton.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        updateUI()
        
        loadData()
    }
}

extension IrregularTagListViewController {
    private func loadData() {
        dataSource.removeAll()
        
        let counts: [Int] = [10, 15, 20, 25, 30]
        for _ in 0...4 {
            var array: [IrregularTagListModel] = []
            for _ in 0..<counts.randomElement()! {
                let width = widths.randomElement()!
                let height = heights.randomElement()!
                let model = IrregularTagListModel(width: width, height: height)
                array.append(model)
            }
            dataSource.append(array)
        }
        
        collectionView.reloadData()
    }
    
    @objc private func directionAction() {
        if direction == .left {
            direction = .right
        } else {
            direction = .left
        }
        collectionView.reloadData()
    }
    
    @objc private func alignmentAction() {
        if alignment == .top {
            alignment = .center
        } else if alignment == .center {
            alignment = .bottom
        } else if alignment == .bottom {
            alignment = .top
        }
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
        if scrollDirection == .vertical {
            if direction == .left {
                directionButton.setTitle("标签排列方向: 左", for: .normal)
            } else if direction == .right {
                directionButton.setTitle("标签排列方向: 右", for: .normal)
            }
            scrollDirectionButton.setTitle("滑动方向: 垂直", for: .normal)
        } else if scrollDirection == .horizontal {
            if direction == .left {
                directionButton.setTitle("标签排列方向: 上", for: .normal)
            } else if direction == .right {
                directionButton.setTitle("标签排列方向: 下", for: .normal)
            }
            scrollDirectionButton.setTitle("滑动方向: 水平", for: .normal)
        }
        
        
        if scrollDirection == .vertical {
            if alignment == .top {
                alignmentButton.setTitle("对齐方向: 顶部对齐", for: .normal)
            } else if alignment == .center {
                alignmentButton.setTitle("对齐方向: 居中对齐", for: .normal)
            } else if alignment == .bottom {
                alignmentButton.setTitle("对齐方向: 底部对齐", for: .normal)
            }
        } else if scrollDirection == .horizontal {
            if alignment == .top {
                alignmentButton.setTitle("对齐方向: 向左对齐", for: .normal)
            } else if alignment == .center {
                alignmentButton.setTitle("对齐方向: 居中对齐", for: .normal)
            } else if alignment == .bottom {
                alignmentButton.setTitle("对齐方向: 向右对齐", for: .normal)
            }
        }
    }
}

extension IrregularTagListViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(IrregularTagListCell.classForCoder()), for: indexPath) as? IrregularTagListCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
}

extension IrregularTagListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.section][indexPath.item]
        return CGSize(width: model.width, height: model.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension IrregularTagListViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .tagList(direction: direction, alignment: alignment)
    }
}
