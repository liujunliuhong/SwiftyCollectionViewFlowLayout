//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

/// `SwiftyCollectionViewFlowLayout`, Inherit `UICollectionViewLayout`
open class SwiftyCollectionViewFlowLayout: UICollectionViewLayout {
    
    internal var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var decorationElementKind: String?
    
    internal var sectionModels: [Int: BaseSectionModel] = [:]
    
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCollectionViewFlowLayout {
    open override func register(_ viewClass: AnyClass?, forDecorationViewOfKind elementKind: String) {
        super.register(viewClass, forDecorationViewOfKind: elementKind)
        decorationElementKind = elementKind
    }
    
    open override func register(_ nib: UINib?, forDecorationViewOfKind elementKind: String) {
        super.register(nib, forDecorationViewOfKind: elementKind)
        decorationElementKind = elementKind
    }
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        //
        sectionModels.removeAll()
        //
        _prepare()
        //
        _layout()
        //
        mDelegate?.collectionView(collectionView, layout: self, contentSizeDidChange: collectionViewContentSize)
        print("prepare")
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elements: [UICollectionViewLayoutAttributes] = []
        for (_, v) in sectionModels.enumerated() {
            let section = v.value
            // header
            if let attr = section.headerLayoutAttributes {
                elements.append(attr)
            }
            // items
            elements.append(contentsOf: section.itemLayoutAttributes)
            // footer
            if let attr = section.footerLayoutAttributes {
                elements.append(attr)
            }
            // group decoration
            if let attr = section.groupDecorationAttributes {
                elements.append(attr)
            }
        }
        return elements
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        //
        var totalLength: CGFloat = .zero
        for (_, v) in sectionModels.enumerated() {
            let section = v.value
            totalLength += section.totalLength(scrollDirection: scrollDirection)
        }
        //
        var size = super.collectionViewContentSize
        switch scrollDirection {
            case .vertical:
                size = CGSize(width: collectionView.bounds.width, height: totalLength)
            case .horizontal:
                size = CGSize(width: totalLength, height: collectionView.bounds.height)
            @unknown default:
                break
        }
        return size
    }
}

extension SwiftyCollectionViewFlowLayout {
    internal func getBeforeSectionTotalLength(currentSection: Int) -> CGFloat {
        var totalLength: CGFloat = .zero
        for (_, element) in sectionModels.enumerated() {
            let section = element.key
            let model = element.value
            if section < currentSection {
                totalLength += model.totalLength(scrollDirection: scrollDirection)
            }
        }
        return totalLength
    }
}
