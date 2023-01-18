//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import UIKit

internal class BaseSectionAttributes {
    var headerLayoutAttributes: UICollectionViewLayoutAttributes?
    var footerLayoutAttributes: UICollectionViewLayoutAttributes?
    var itemLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var sectionInset: UIEdgeInsets = .zero
    var lineSpacing: CGFloat = .zero
    var interitemSpacing: CGFloat = .zero
    var sectionInsetContainHeader: Bool = false
    var sectionInsetContainFooter: Bool = false
}

internal class WaterFlowSectionAttributes: BaseSectionAttributes {
    
    var bodyColumnLengths: [Int: CGFloat] = [:]
    
    
    /// 当前Section的Body总长度
    var maxBodyLength: CGFloat {
        var maxLength: CGFloat = .zero
        for length in bodyColumnLengths.values {
            if !length.isLessThanOrEqualTo(maxLength) {
                maxLength = length
            }
        }
        return maxLength
    }
    
    // 当前Section的Footer之前的长度
    func footerBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        
        if scrollDirection == .vertical {
            if sectionInsetContainHeader {
                length += sectionInset.top
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.height
                }
            } else {
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.height
                }
                length += sectionInset.top
            }
            //
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.height
            }
            //
            if sectionInsetContainFooter {
                length += .zero
            } else {
                length += sectionInset.bottom
            }
        } else {
            if sectionInsetContainHeader {
                length += sectionInset.left
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.width
                }
            } else {
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.width
                }
                length += sectionInset.left
            }
            //
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.width
            }
            //
            if sectionInsetContainFooter {
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.width
                }
                length += sectionInset.right
            } else {
                length += sectionInset.right
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.width
                }
            }
        }
        return length
    }
    
    /// 当前Section总长度
    func totalLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        
        if scrollDirection == .vertical {
            if sectionInsetContainHeader {
                length += sectionInset.top
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.height
                }
            } else {
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.height
                }
                length += sectionInset.top
            }
            //
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.height
            }
            //
            if sectionInsetContainFooter {
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.height
                }
                length += sectionInset.bottom
            } else {
                length += sectionInset.bottom
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.height
                }
            }
        } else {
            if sectionInsetContainHeader {
                length += sectionInset.left
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.width
                }
            } else {
                if let headerAttr = headerLayoutAttributes {
                    length += headerAttr.frame.width
                }
                length += sectionInset.left
            }
            //
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.width
            }
            //
            if sectionInsetContainFooter {
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.width
                }
                length += sectionInset.right
            } else {
                length += sectionInset.right
                if let footerAttr = footerLayoutAttributes {
                    length += footerAttr.frame.width
                }
            }
        }
        return length
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
        
        let numberOfSections = collectionView.numberOfSections
        
        for section in 0..<numberOfSections {
            let indexPath = IndexPath(item: 0, section: section)
            
            let sectionInset = mDelegate?.collectionView?(collectionView,
                                                          layout: self,
                                                          insetForSectionAt: section) ?? .zero
            
            let sectionInsetContainHeader = mDelegate?.collectionView(collectionView,
                                                                      layout: self,
                                                                      sectionInsetContainHeader: indexPath.section) ?? false
            
            let sectionInsetContainFooter = mDelegate?.collectionView(collectionView,
                                                                      layout: self,
                                                                      sectionInsetContainFooter: indexPath.section) ?? false
            
            let lineSpacing = mDelegate?.collectionView?(collectionView,
                                                         layout: self,
                                                         minimumLineSpacingForSectionAt: section) ?? .zero
            
            let interitemSpacing = mDelegate?.collectionView?(collectionView,
                                                              layout: self,
                                                              minimumInteritemSpacingForSectionAt: section) ?? .zero
            
            
            
            
            
            var bodyColumnHeights: [Int: CGFloat] = [:]
            for column in 0..<numberOfColumns {
                bodyColumnHeights[column] = .zero
            }
            
            let waterFlowSectionAttr = WaterFlowSectionAttributes()
            waterFlowSectionAttr.sectionInset = sectionInset
            waterFlowSectionAttr.sectionInsetContainHeader = sectionInsetContainHeader
            waterFlowSectionAttr.sectionInsetContainFooter = sectionInsetContainFooter
            waterFlowSectionAttr.lineSpacing = lineSpacing
            waterFlowSectionAttr.interitemSpacing = interitemSpacing
            waterFlowSectionAttr.bodyColumnHeights = bodyColumnHeights
            
            waterFlowSectionAttributes[section] = waterFlowSectionAttr
        }
        
        for section in 0..<numberOfSections {
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            
            
            
            
            // header
            let headerSection = IndexPath(item: 0, section: section)
            if let attr = _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerSection) {
                
            }
            
            
            // item
            for index in 0..<numberOfItems {
                let itemIndexPath = IndexPath(item: index, section: section)
                if let attr = _layoutAttributesForItem(at: itemIndexPath) {
                    
                }
            }
            
            // footer
            let footerSection = IndexPath(item: 0, section: section)
            if let attr = _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerSection) {
                
            }
            
            
            var bodyColumnHeights: [Int: CGFloat] = [:]
            for column in 0..<numberOfColumns {
                bodyColumnHeights[column] = .zero
            }
            
            let waterFlowSectionAttr = WaterFlowSectionAttributes()
            waterFlowSectionAttr.sectionInset = sectionInset
            waterFlowSectionAttr.sectionInsetContainHeader = sectionInsetContainHeader
            waterFlowSectionAttr.sectionInsetContainFooter = sectionInsetContainFooter
            waterFlowSectionAttr.lineSpacing = lineSpacing
            waterFlowSectionAttr.interitemSpacing = interitemSpacing
            waterFlowSectionAttr.bodyColumnHeights = bodyColumnHeights
            
            waterFlowSectionAttributes[section] = waterFlowSectionAttr
        }
    }
    
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let cellAttr = layoutAttributesForItem(at: indexPath) else { return nil }
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        let sectionAttr = waterFlowSectionAttributes[indexPath.section]! // 一定存在
        
        let numberOfColumns = sectionAttr.bodyColumnLengths.count
        
        if numberOfColumns <= 0 {
            return nil
        }
        
        let sectionInset = sectionAttr.sectionInset
        
        var minElement: Dictionary<Int, CGFloat>.Element!
        
        // Set row = 0, Default minElement
        for (_, element) in sectionAttr.bodyColumnLengths.enumerated() {
            if element.key == 0 {
                minElement = element
                break
            }
        }
        // Find minElement
        for (_, element) in sectionAttr.bodyColumnLengths.enumerated() {
            if element.value.isLess(than: minElement.value) {
                minElement = element
            }
        }
        
        //
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
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = sectionAttr.lineSpacing + minElement.value
            }
            item_y += changeLength
            
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionAttr.interitemSpacing + columnHeight) * CGFloat(minElement.key)
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = sectionAttr.lineSpacing + minElement.value
            }
            item_x += changeLength
        }
        
        // Update bodyColumnLengths
        sectionAttr.bodyColumnLengths[minElement.key] = minElement.value + changeLength
        
        // Update Cell Attr
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        
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
    private func _layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let supplementaryViewAttr = layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        
        let sectionInset = mDelegate?.collectionView?(collectionView,
                                                      layout: self,
                                                      insetForSectionAt: indexPath.section) ?? .zero
        
        let sectionInsetContainHeader = mDelegate?.collectionView(collectionView,
                                                                  layout: self,
                                                                  sectionInsetContainHeader: indexPath.section) ?? false
        
        let sectionInsetContainFooter = mDelegate?.collectionView(collectionView,
                                                                  layout: self,
                                                                  sectionInsetContainFooter: indexPath.section)
        
        var sectionAttr: WaterFlowSectionAttributes!
        if let atr = waterFlowSectionAttributes[indexPath.section] {
            sectionAttr = atr
        } else {
            sectionAttr = WaterFlowSectionAttributes()
        }
        sectionAttr.sectionInsetContainHeader = sectionInsetContainHeader
        sectionAttr.sectionInsetContainFooter = sectionInsetContainFooter
        waterFlowSectionAttributes[indexPath.section] = sectionAttr
        
        
        let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: indexPath.section)
        
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            
            let headerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            
            
            
            var header_x: CGFloat = .zero
            var header_y: CGFloat = .zero
            var header_width: CGFloat = .zero
            var header_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                if sectionInsetContainHeader {
                    header_x = sectionInset.left
                    header_y = beforeSectionTotalLength + sectionInset.top
                    header_width = collectionView.frame.width - sectionInset.left - sectionInset.right
                } else {
                    header_x = .zero
                    header_y = beforeSectionTotalLength
                    header_width = collectionView.frame.width
                }
                header_height = headerSize.height
            } else if scrollDirection == .horizontal {
                if sectionInsetContainHeader {
                    header_x = beforeSectionTotalLength + sectionInset.left
                    header_y = sectionInset.top
                    header_height = collectionView.frame.height - sectionInset.top - sectionInset.bottom
                } else {
                    header_x = beforeSectionTotalLength
                    header_y = .zero
                    header_height = collectionView.frame.height
                }
                header_width = headerSize.width
            }
            
            supplementaryViewAttr.frame = CGRect(x: header_x,
                                                 y: header_y,
                                                 width: header_width,
                                                 height: header_height)
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            let footerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForFooterInSection: indexPath.section)
            
            
            
            
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
    
    private func _layoutWaterFlowAttributesForItem(at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        guard let cellAttr = layoutAttributesForItem(at: indexPath) else { return }
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        let sectionAttr = waterFlowSectionAttributes[indexPath.section]! // 一定存在
        
        let numberOfColumns = sectionAttr.bodyColumnLengths.count
        
        if numberOfColumns <= 0 {
            return
        }
        
        let sectionInset = sectionAttr.sectionInset
        
        var minElement: Dictionary<Int, CGFloat>.Element!
        
        // Set row = 0, Default minElement
        for (_, element) in sectionAttr.bodyColumnLengths.enumerated() {
            if element.key == 0 {
                minElement = element
                break
            }
        }
        // Find minElement
        for (_, element) in sectionAttr.bodyColumnLengths.enumerated() {
            if element.value.isLess(than: minElement.value) {
                minElement = element
            }
        }
        
        //
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
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = sectionAttr.lineSpacing + minElement.value
            }
            item_y += changeLength
            
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionAttr.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionAttr.interitemSpacing + columnHeight) * CGFloat(minElement.key)
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                changeLength = sectionAttr.lineSpacing + minElement.value
            }
            item_x += changeLength
        }
        
        // Update Cell Attr
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        
        // Update Section Model
        sectionAttr.bodyColumnLengths[minElement.key] = minElement.value + changeLength
        sectionAttr.itemLayoutAttributes.append(cellAttr)
    }
    
    
    
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
