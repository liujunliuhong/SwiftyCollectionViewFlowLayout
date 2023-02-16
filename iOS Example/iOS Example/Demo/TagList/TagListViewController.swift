//
//  TagListViewController.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import UIKit
import SnapKit
import SwiftyCollectionViewFlowLayout

public final class TagListViewController: UIViewController {
    
    private let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "银河系", "大麦哲伦云", "小麦哲伦云", "比邻星", "拉尼亚凯亚超星系团", "仙女座星系", "武仙-北冕长城", "猎户座", "史隆长城", "超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字", "室女座超星系团"]
    
    private lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 35)
        label.text = "标签列表，根据内容动态调整高度"
        return label
    }()
    
    private lazy var layout: SwiftyCollectionViewFlowLayout = {
        let layout = SwiftyCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var randomButton: UIButton = {
        let randomButton = UIButton(type: .system)
        randomButton.setTitle("点我随机一下", for: .normal)
        randomButton.addTarget(self, action: #selector(randomAction), for: .touchUpInside)
        return randomButton
    }()
    
    private lazy var directionButton: UIButton = {
        let directionButton = UIButton(type: .system)
        directionButton.addTarget(self, action: #selector(directionAction), for: .touchUpInside)
        return directionButton
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
    
    private var direction: SwiftyCollectionViewRowDirection = .left {
        didSet {
            updateDirectionButtonText()
        }
    }
    private var dataSource: [TagListModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(desLabel)
        view.addSubview(randomButton)
        view.addSubview(directionButton)
        view.addSubview(collectionView)
        
        updateDirectionButtonText()
        
        desLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(120)
        }
        randomButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(45)
            make.top.equalTo(desLabel.snp.bottom).offset(15)
        }
        directionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.height.equalTo(randomButton)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalTo(randomButton.snp.bottom).offset(15)
            make.height.equalTo(20) // 高度随便设置一个值
        }
        
        loadData()
    }
    
    @objc private func randomAction() {
        loadData()
    }
    
    @objc private func directionAction() {
        if direction == .left {
            direction = .right
        } else {
            direction = .left
        }
        collectionView.reloadData()
    }
    
    private func updateDirectionButtonText() {
        switch direction {
            case .left:
                directionButton.setTitle("标签排列方向: 左", for: .normal)
            case .right:
                directionButton.setTitle("标签排列方向: 右", for: .normal)
        }
    }
}

extension TagListViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TagListCell.classForCoder()), for: indexPath) as? TagListCell else {
            return UICollectionViewCell()
        }
        let model = dataSource[indexPath.item]
        cell.bind(to: model)
        return cell
    }
}

extension TagListViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .row(direction: direction, alignment: .center)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        return .init(width: .dynamic(increment: 15), height: .absolute(35))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, contentSizeDidChange size: CGSize) {
        
        print("✋🏻CollectionView ContentSize: \(size)")
        
        // Update collectionView constraints
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(size.height)
        }
    }
}

extension TagListViewController {
    private func loadData() {
        
        let titles = titles.shuffled()
        var randomCount = arc4random() % UInt32(titles.count)
        if randomCount <= 0 {
            randomCount = 1
        }
        
        dataSource = titles.prefix(Int(randomCount)).map{ TagListModel(title: $0) }
        
        collectionView.reloadData()
    }
}
