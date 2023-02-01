//
//  TagListViewController.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import UIKit
import SnapKit

public final class TagListViewController: UIViewController {

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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.register(TagListCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TagListCell.classForCoder()))
        return collectionView
    }()
    
    private var dataSource: [TagListModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(desLabel)
        view.addSubview(collectionView)
        
        desLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(120)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalTo(desLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        loadData()
        collectionView.reloadData()
        
        collectionView.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let contentHeight = self.layout.collectionViewContentSize.height
            print("😄\(contentHeight)")
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
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

extension TagListViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.item]
        let height: CGFloat = 35
        let width = ((model.title ?? "") as NSString).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: model.font], context: nil).width + 25
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension TagListViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        return .tagList(alignment: .center)
    }
}

extension TagListViewController {
    private func loadData() {
        let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "银河系", "大麦哲伦", "小麦哲伦", "比邻星", "拉尼亚凯亚超星系团", "史隆长城", "超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字超长文字", "室女座超星系团"].shuffled()
        
        dataSource = titles.map{ TagListModel(title: $0) }
    }
}
