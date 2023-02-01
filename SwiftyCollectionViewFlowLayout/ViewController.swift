//
//  ViewController.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import UIKit

fileprivate class Layout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        print("😄prepare")
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atr = super.layoutAttributesForItem(at: indexPath)
        
        print("😄layoutAttributesForItem indexPath: \(indexPath)  atr: \(atr)")
        
        return atr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atr = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        print("😄layoutAttributesForSupplementaryView elementKind: \(elementKind) indexPath: \(indexPath)  atr: \(atr)")
        
        return atr
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atr = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        
        print("😄layoutAttributesForDecorationView elementKind: \(elementKind) indexPath: \(indexPath) atr: \(atr)")
        
        return atr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        
        print("😄layoutAttributesForElements  rect: \(rect) attrs: \(attrs)")
        
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        let size = super.collectionViewContentSize
        
        print("😄collectionViewContentSize  size: \(size)")
        
        return size
    }
}

fileprivate class Cell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class HeaderSupplementary: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class FooterSupplementary: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


fileprivate class Model {
    var width: CGFloat = .zero
    var height: CGFloat = .zero
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

public final class ViewController: UIViewController {

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = Layout()
        //let layout = SwiftyCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 30, y: 90, width: view.bounds.width - 30 - 30, height: view.bounds.height - 90 - 90)
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.register(Cell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(Cell.classForCoder()))
        collectionView.register(HeaderSupplementary.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HeaderSupplementary.classForCoder()))
        collectionView.register(FooterSupplementary.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(FooterSupplementary.classForCoder()))
        return collectionView
    }()
    
    private var heights: [CGFloat] {
        return [20, 30, 40, 50, 60, 70]
    }
    
    private var widths: [CGFloat] {
        return [40, 50, 60, 70, 80, 90]
    }
    
    private var dataSource: [[Model]] = []
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        
        var dataSource: [[Model]] = []
        for _ in 0...5 {
            var items: [Model] = []
            for _ in 0...15 {
                let model = Model(width: widths.randomElement()!, height: heights.randomElement()!)
                items.append(model)
            }
            dataSource.append(items)
        }
        self.dataSource = dataSource
        self.collectionView.reloadData()
        
        collectionView.layoutIfNeeded()
        print("😄😄😄\(layout.collectionViewContentSize)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let insertModel = Model(width: 25, height: 25)
//
//            let insertSection: Int = 0
//            let insetItem: Int = 1
//
//            self.dataSource[insertSection].insert(insertModel, at: insetItem)
//
//            let insertIndexPath = IndexPath(item: insetItem, section: insertSection)
//
//            self.collectionView.performBatchUpdates { [weak self] in
//                guard let self = self else { return }
//                self.collectionView.insertItems(at: [insertIndexPath])
//            }
            
            
            
            let updateSection: Int = 0
            let updateRow: Int = 1
            
            let reloadPath = IndexPath(item: updateRow, section: updateSection)
            
            let updateModel = self.dataSource[updateSection][updateRow]
            updateModel.width = 150
            updateModel.height = 150
            
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadItems(at: [reloadPath])
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(Cell.classForCoder()), for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.section) - \(indexPath.item)"
        return cell
    }
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.section][indexPath.item]
        return CGSize(width: model.width, height: model.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(HeaderSupplementary.classForCoder()), for: indexPath) as? HeaderSupplementary else {
                return UICollectionReusableView()
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(FooterSupplementary.classForCoder()), for: indexPath) as? FooterSupplementary else {
                return UICollectionReusableView()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension ViewController: SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionType section: Int) -> SwiftyCollectionViewSectionType {
        if section == 0 {
            return .tagList(alignment: .bottom)
        } else if section == 1 {
            return .waterFlow(numberOfColumns: 3)
        } else {
            return .waterFlow(numberOfColumns: 4)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainFooter section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SwiftyCollectionViewFlowLayout, sectionInsetContainHeader section: Int) -> Bool {
        return true
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
