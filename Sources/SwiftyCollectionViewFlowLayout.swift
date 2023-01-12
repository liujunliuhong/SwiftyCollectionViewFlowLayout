//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import UIKit

class WaterFlowSectionAttributes {
    var sectionInset: UIEdgeInsets = .zero
    var headerSize: CGSize = .zero
    var footerSize: CGSize = .zero
    
    var lineSpacing: CGFloat = .zero
    var interitemSpacing: CGFloat = .zero
    
    var body: [Int: CGFloat] = [:]
    
    
    /// 当前Section的Body总长度
    var maxBodyLength: CGFloat {
        var maxLength: CGFloat = .zero
        for length in body.values {
            if !length.isLessThanOrEqualTo(maxLength) {
                maxLength = length
            }
        }
        return maxLength
    }
    
    /// 当前Section总长度
    func totalLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        if scrollDirection == .vertical {
            return headerSize.height + sectionInset.top + maxBodyLength + sectionInset.bottom + footerSize.height
        } else if scrollDirection == .horizontal {
            return headerSize.width + sectionInset.left + maxBodyLength + sectionInset.right + footerSize.width
        }
        return .zero
    }
}

open class SwiftyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    
    private var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    private var waterFlowSectionAttributes: [Int: WaterFlowSectionAttributes] = [:]
    private var attributesForElements: [UICollectionViewLayoutAttributes] = []
    
    public override init() {
        super.init() 
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCollectionViewFlowLayout {
    open override func prepare() {
        super.prepare()
       
        guard let collectionView = collectionView else { return }
        
        
        waterFlowSectionAttributes.removeAll()
        attributesForElements.removeAll()
        
        for section in 0..<collectionView.numberOfSections {
            let sectionInset = mDelegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? .zero
            let sectionHeaderSize = mDelegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? .zero
            let sectionFooterSize = mDelegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? .zero
            
            let lineSpacing = mDelegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? .zero
            let interitemSpacing = mDelegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? .zero
            
            let numberOfColumns = mDelegate?.collectionView(collectionView, layout: self, numberOfColumnsInSection: section) ?? 0
            
            var body: [Int: CGFloat] = [:]
            for column in 0..<numberOfColumns {
                body[column] = .zero
            }
            
            let waterFlowSectionAttr = WaterFlowSectionAttributes()
            waterFlowSectionAttr.sectionInset = sectionInset
            waterFlowSectionAttr.headerSize = sectionHeaderSize
            waterFlowSectionAttr.footerSize = sectionFooterSize
            waterFlowSectionAttr.lineSpacing = lineSpacing
            waterFlowSectionAttr.interitemSpacing = interitemSpacing
            waterFlowSectionAttr.body = body
            
            waterFlowSectionAttributes[section] = waterFlowSectionAttr
        }
    }
    
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let cellAttr = super.layoutAttributesForItem(at: indexPath) else { return nil }
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        let sectionAttr = waterFlowSectionAttributes[indexPath.section]! // 一定存在
        
        let numberOfColumns = sectionAttr.body.count
        
        if numberOfColumns <= 0 {
            return nil
        }
        
        let sectionInset = sectionAttr.sectionInset
        let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: indexPath.section)
        
        var minElement: Dictionary<Int, CGFloat>.Element!
        for (_, element) in sectionAttr.body.enumerated() {
            if element.key == 0 {
                minElement = element
                break
            }
        }
        for (_, element) in sectionAttr.body.enumerated() {
            if element.value.isLess(than: minElement.value) {
                minElement = element
            }
        }
        
        var item_x: CGFloat = .zero
        var item_y: CGFloat = .zero
        var item_width: CGFloat = .zero
        var item_height: CGFloat = .zero
        var changeLength: CGFloat = .zero
        
        if scrollDirection == .vertical {
            let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = columnWidth
            item_height = itemSize.height
            
            item_x = sectionInset.left + (sectionAttr.interitemSpacing + columnWidth) * CGFloat(minElement.key)
            
            item_y = beforeSectionTotalLength + sectionAttr.headerSize.height + sectionInset.top
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = item_height + sectionAttr.lineSpacing
            }
            item_y += changeLength
            
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionAttr.interitemSpacing + columnHeight) * CGFloat(minElement.key)
            
            item_x = beforeSectionTotalLength + sectionAttr.headerSize.width + sectionInset.left
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = item_width + sectionAttr.lineSpacing
            }
            item_x += changeLength
        }
        
        // Update Body
        sectionAttr.body[minElement.key] = minElement.value + changeLength
        
        // Update Cell Attr
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        
        attributesForElements.append(cellAttr)
        
        return cellAttr
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let supplementaryViewAttr = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        
        let sectionAttr = waterFlowSectionAttributes[indexPath.section]! // 一定存在
        
        var header_x: CGFloat = .zero
        var header_y: CGFloat = .zero
        var header_width: CGFloat = .zero
        var header_height: CGFloat = .zero
        
        let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: indexPath.section)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            
            let headerSize = sectionAttr.headerSize
            
            if scrollDirection == .vertical {
                header_x = .zero
                header_y = beforeSectionTotalLength
                header_width = collectionView.frame.width
                header_height = headerSize.height
            } else if scrollDirection == .horizontal {
                header_x = beforeSectionTotalLength
                header_y = .zero
                header_width = headerSize.width
                header_height = collectionView.frame.height
            }
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            let footerSize = sectionAttr.footerSize
            
            if scrollDirection == .vertical {
                header_x = .zero
                header_y = beforeSectionTotalLength + sectionAttr.headerSize.height + sectionAttr.sectionInset.top + sectionAttr.maxBodyLength + sectionAttr.sectionInset.bottom
                header_width = collectionView.frame.width
                header_height = footerSize.height
            } else if scrollDirection == .horizontal {
                header_x = beforeSectionTotalLength + sectionAttr.headerSize.width + sectionAttr.sectionInset.left + sectionAttr.maxBodyLength + sectionAttr.sectionInset.right
                header_y = .zero
                header_width = footerSize.width
                header_height = collectionView.frame.height
            }
        }
        
        supplementaryViewAttr.frame = CGRect(x: header_x, y: header_y, width: header_width, height: header_height)
        
        attributesForElements.append(supplementaryViewAttr)
        
        return supplementaryViewAttr
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let decorationAttr = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath) else { return nil }
        
        
        return decorationAttr
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesForElements
    }
    
    open override var collectionViewContentSize: CGSize {
        return .zero
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func getBeforeSectionTotalLength(currentSection: Int) -> CGFloat {
        var totalLength: CGFloat = .zero
        
        for (_, element) in waterFlowSectionAttributes.enumerated() {
            let section = element.key
            let attr = element.value
            if section < currentSection {
                totalLength += attr.totalLength(scrollDirection: scrollDirection)
            }
        }
        return totalLength
    }
}
