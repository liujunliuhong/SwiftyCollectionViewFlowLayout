//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit


open class SwiftyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    private var sectionModels: [Int: BaseSectionModel] = [:]
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
        
        sectionModels.removeAll()
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
            
            let sectionType = mDelegate?.collectionView(collectionView,
                                                        layout: self,
                                                        sectionType: section) ?? .normal
            
            switch sectionType {
                case .waterFlow:
                    let numberOfColumns = mDelegate?.collectionView(collectionView,
                                                                    layout: self,
                                                                    numberOfColumnsInSection: section) ?? 1
                    var bodyColumnLengths: [Int: CGFloat] = [:]
                    for column in 0..<numberOfColumns {
                        bodyColumnLengths[column] = .zero
                    }
                    var waterFlowSectionModel = WaterFlowSectionModel()
                    waterFlowSectionModel.sectionInset = sectionInset
                    waterFlowSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
                    waterFlowSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
                    waterFlowSectionModel.lineSpacing = lineSpacing
                    waterFlowSectionModel.interitemSpacing = interitemSpacing
                    waterFlowSectionModel.sectionType = .waterFlow
                    
                    waterFlowSectionModel.bodyColumnLengths = bodyColumnLengths
                    
                    sectionModels[section] = waterFlowSectionModel
                case .normal:
                    var normalSectionModel = NormalSectionModel()
                    normalSectionModel.sectionInset = sectionInset
                    normalSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
                    normalSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
                    normalSectionModel.lineSpacing = lineSpacing
                    normalSectionModel.interitemSpacing = interitemSpacing
                    normalSectionModel.sectionType = .normal
                    sectionModels[section] = normalSectionModel
                default:
                    break
            }
        }
        
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            // header
            let headerSection = IndexPath(item: 0, section: section)
            _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerSection)
            if let sectionModel = sectionModels[section] {
                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                if let attr = sectionModel.headerLayoutAttributes {
                    var frame = attr.frame
                    if scrollDirection == .vertical {
                        frame.origin.y = beforeSectionTotalLength
                    } else if scrollDirection == .horizontal {
                        frame.origin.x = beforeSectionTotalLength
                    }
                    attr.frame = frame // update header frame
                }
            }
            // item
            for index in 0..<numberOfItems {
                let itemIndexPath = IndexPath(item: index, section: section)
                _layoutWaterFlowAttributesForItem(at: itemIndexPath)
            }
            if let sectionModel = sectionModels[section] {
                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                for attr in sectionModel.itemLayoutAttributes {
                    var frame = attr.frame
                    if scrollDirection == .vertical {
                        frame.origin.y = (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
                    } else if scrollDirection == .horizontal {
                        frame.origin.x = (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
                    }
                    attr.frame = frame // update item frame
                }
            }
            // footer
            let footerSection = IndexPath(item: 0, section: section)
            _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerSection)
            if let sectionModel = sectionModels[section] {
                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                if let attr = sectionModel.footerLayoutAttributes {
                    var frame = attr.frame
                    if scrollDirection == .vertical {
                        frame.origin.y = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                    } else if scrollDirection == .horizontal {
                        frame.origin.x = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                    }
                    attr.frame = frame // update footer frame
                }
            }
        }
    }
    
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elements: [UICollectionViewLayoutAttributes] = []
        for (_, v) in sectionModels.enumerated() {
            let section = v.value
            if let attr = section.headerLayoutAttributes {
                elements.append(attr)
            }
            elements.append(contentsOf: section.itemLayoutAttributes)
            if let attr = section.footerLayoutAttributes {
                elements.append(attr)
            }
        }
        return elements
    }
    
    open override var collectionViewContentSize: CGSize {
        return .zero
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func _layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return nil }
        guard let supplementaryViewAttr = layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        
        let sectionModel = sectionModels[indexPath.section]! // 一定存在
        
        let sectionInset = sectionModel.sectionInset
        let sectionInsetContainHeader = sectionModel.sectionInsetContainHeader
        let sectionInsetContainFooter = sectionModel.sectionInsetContainFooter
        
        let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: indexPath.section)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            // Header
            let headerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            var header_x: CGFloat = .zero
            var header_y: CGFloat = .zero
            var header_width: CGFloat = .zero
            var header_height: CGFloat = .zero
            
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
            supplementaryViewAttr.frame = CGRect(x: header_x,
                                                 y: header_y,
                                                 width: header_width,
                                                 height: header_height)
            
            sectionModel.headerLayoutAttributes = supplementaryViewAttr
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            // Footer
            let footerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForFooterInSection: indexPath.section) ?? .zero
            
            var footer_x: CGFloat = .zero
            var footer_y: CGFloat = .zero
            var footer_width: CGFloat = .zero
            var footer_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                footer_x = .zero
                footer_y = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                footer_width = collectionView.frame.width
                footer_height = footerSize.height
            } else if scrollDirection == .horizontal {
                footer_x = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                footer_y = .zero
                footer_width = footerSize.width
                footer_height = collectionView.frame.height
            }
            supplementaryViewAttr.frame = CGRect(x: footer_x,
                                                 y: footer_y,
                                                 width: footer_width,
                                                 height: footer_height)
            sectionModel.footerLayoutAttributes = supplementaryViewAttr
        }
    }
    
    private func _layoutWaterFlowAttributesForItem(at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        guard let sectionModel = sectionModels[indexPath.section] as? WaterFlowSectionModel else { return }
        guard let cellAttr = layoutAttributesForItem(at: indexPath) else { return }
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        let numberOfColumns = sectionModel.bodyColumnLengths.count
        
        if numberOfColumns <= 0 { return }
        
        let sectionInset = sectionModel.sectionInset
        
        var minElement: Dictionary<Int, CGFloat>.Element!
        
        // Set row = 0, Default minElement
        for (_, element) in sectionModel.bodyColumnLengths.enumerated() {
            if element.key == 0 {
                minElement = element
                break
            }
        }
        // Find minElement
        for (_, element) in sectionModel.bodyColumnLengths.enumerated() {
            if element.value.isLess(than: minElement.value) {
                minElement = element
            }
        }
        
        //
        var item_x: CGFloat = .zero
        var item_y: CGFloat = .zero
        var item_width: CGFloat = .zero
        var item_height: CGFloat = .zero
        
        if scrollDirection == .vertical {
            let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = columnWidth
            item_height = itemSize.height
            
            item_x = sectionInset.left + (sectionModel.interitemSpacing + columnWidth) * CGFloat(minElement.key)
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                item_y = minElement.value + sectionModel.lineSpacing
                sectionModel.bodyColumnLengths[minElement.key] = minElement.value + sectionModel.lineSpacing + item_height
            }
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionModel.interitemSpacing + columnHeight) * CGFloat(minElement.key)
            
            if !minElement.value.isLessThanOrEqualTo(.zero) {
                item_x = minElement.value + sectionModel.lineSpacing
                sectionModel.bodyColumnLengths[minElement.key] = minElement.value + sectionModel.lineSpacing + item_width
            }
        }
        // Update Cell Attr
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        // Update Section Model
        sectionModel.itemLayoutAttributes.append(cellAttr)
    }
    
    
    
    private func getBeforeSectionTotalLength(currentSection: Int) -> CGFloat {
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
