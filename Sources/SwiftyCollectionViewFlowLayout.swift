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
    
    
    /// 当前Section的Body总高度
    var maxBodyHeight: CGFloat {
        var maxHeight: CGFloat = .zero
        for height in body.values {
            if !height.isLessThanOrEqualTo(maxHeight) {
                maxHeight = height
            }
        }
        return maxHeight
    }
    
    /// 当前Section总高度
    func totalHeight(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        if scrollDirection == .vertical {
            return headerSize.height + sectionInset.top + maxBodyHeight + sectionInset.bottom + footerSize.height
        } else if scrollDirection == .horizontal {
            return headerSize.width + sectionInset.left + maxBodyHeight + sectionInset.right + footerSize.width
        }
        return .zero
    }
    
    /// 当前Section Body之前的高度
    var bodyBeforeHeight: CGFloat {
        return headerHeight + inset.top
    }
    
    /// 当前Section Footer之前的高度
    var footerBeforeHeight: CGFloat {
        return headerHeight + inset.top + maxBodyHeight + inset.bottom
    }
}

open class SwiftyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    
    private var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    private var waterFlowSectionAttributes: [Int: WaterFlowSectionAttributes] = [:]
    
    
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
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return []
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let cellAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        
        let sectionAttr = waterFlowSectionAttributes[indexPath.section]! // 一定存在
        
        let numberOfColumns = sectionAttr.body.count
        
        if numberOfColumns <= 0 {
            return nil
        }
        
        let sectionInset = sectionAttr.sectionInset
        
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
        
        if scrollDirection == .vertical {
            let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = columnWidth
            item_height = itemSize.height
            
            item_x = sectionInset.left + (sectionAttr.interitemSpacing + columnWidth) * CGFloat(minElement.key)
            
            item_y = getBeforeSectionTotalHeight(currentSection: indexPath.section) + sectionAttr.headerSize.height + sectionInset.top
            
            var changeHeight: CGFloat = .zero
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeHeight = item_height + sectionAttr.lineSpacing
            }
            item_y += changeHeight
            
            // Update Body
            sectionAttr.body[minElement.key] = minElement.value + changeHeight
            
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionAttr.interitemSpacing + columnHeight) * CGFloat(minElement.key)
            
            item_x = getBeforeSectionTotalHeight(currentSection: indexPath.section) + sectionAttr.headerSize.width + sectionInset.left
            
            var changeWidth: CGFloat = .zero
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeWidth = item_width + sectionAttr.lineSpacing
            }
            item_x += changeWidth
            
            // Update Body
            sectionAttr.body[minElement.key] = minElement.value + changeWidth
        }
        
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        
        
        
        return cellAttr
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            let headerSize = mDelegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            
            let beforeHeight = getBeforeSectionTotalHeight(currentSection: indexPath.section)
            
            var header_x: CGFloat = .zero
            var header_y: CGFloat = .zero
            var header_width: CGFloat = .zero
            var header_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                header_x = .zero
                header_y = beforeHeight
                header_width = collectionView.frame.width
                header_height = headerSize.height
            } else if scrollDirection == .horizontal {
                header_x = beforeHeight
                header_y = .zero
                header_width = headerSize.width
                header_height = collectionView.frame.height
            }
            
            attr.frame = CGRect(x: header_x, y: header_y, width: header_width, height: header_height)
            
            if let attr = waterFlowSectionAttributes[indexPath.section] {
                attr.headerHeight = headerSize.height
            } else {
                let attr = WaterFlowSectionAttributes()
                attr.headerHeight = headerSize.height
                waterFlowSectionAttributes[indexPath.section] = attr
            }
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            let footerSize = mDelegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: indexPath.section) ?? .zero
            
            var beforeHeight = getBeforeSectionTotalHeight(currentSection: indexPath.section)
            
            if let attr = waterFlowSectionAttributes[indexPath.section] {
                beforeHeight += attr.footerBeforeHeight
            }
            
            var header_x: CGFloat = .zero
            var header_y: CGFloat = .zero
            var header_width: CGFloat = .zero
            var header_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                header_x = .zero
                header_y = beforeHeight
                header_width = collectionView.frame.width
                header_height = footerSize.height
            } else if scrollDirection == .horizontal {
                header_x = beforeHeight
                header_y = .zero
                header_width = footerSize.width
                header_height = collectionView.frame.height
            }
            
            attr.frame = CGRect(x: header_x, y: header_y, width: header_width, height: header_height)
            
            if let attr = waterFlowSectionAttributes[indexPath.section] {
                attr.footerHeight = footerSize.height
            } else {
                let attr = WaterFlowSectionAttributes()
                attr.footerHeight = footerSize.height
                waterFlowSectionAttributes[indexPath.section] = attr
            }
        }
        return nil
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    open override var collectionViewContentSize: CGSize {
        return .zero
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func getBeforeSectionTotalHeight(currentSection: Int) -> CGFloat {
        var totalHeight: CGFloat = .zero
        
        for (_, element) in waterFlowSectionAttributes.enumerated() {
            let section = element.key
            let attr = element.value
            if section < currentSection {
                totalHeight += attr.totalHeight(scrollDirection: scrollDirection)
            }
        }
        return totalHeight
    }
}
