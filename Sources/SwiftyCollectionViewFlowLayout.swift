//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

open class SwiftyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    internal var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    internal var sectionModels: [Int: BaseSectionModel] = [:]
    
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
        //
        guard let collectionView = collectionView else { return }
        //
        sectionModels.removeAll()
        //
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
                case .waterFlow(let numberOfColumns):
                    var bodyColumnLengths: [CGFloat] = []
                    for _ in 0..<numberOfColumns {
                        bodyColumnLengths.append(.zero)
                    }
                    let waterFlowSectionModel = WaterFlowSectionModel()
                    waterFlowSectionModel.sectionInset = sectionInset
                    waterFlowSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
                    waterFlowSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
                    waterFlowSectionModel.lineSpacing = lineSpacing
                    waterFlowSectionModel.interitemSpacing = interitemSpacing
                    waterFlowSectionModel.sectionType = sectionType
                    
                    waterFlowSectionModel.bodyColumnLengths = bodyColumnLengths
                    
                    sectionModels[section] = waterFlowSectionModel
                case .normal:
                    let normalSectionModel = NormalSectionModel()
                    normalSectionModel.sectionInset = sectionInset
                    normalSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
                    normalSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
                    normalSectionModel.lineSpacing = lineSpacing
                    normalSectionModel.interitemSpacing = interitemSpacing
                    normalSectionModel.sectionType = sectionType
                    sectionModels[section] = normalSectionModel
                case .tagList:
                    let tagListSectionModel = TagListSectionModel()
                    tagListSectionModel.sectionInset = sectionInset
                    tagListSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
                    tagListSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
                    tagListSectionModel.lineSpacing = lineSpacing
                    tagListSectionModel.interitemSpacing = interitemSpacing
                    tagListSectionModel.sectionType = sectionType
                    sectionModels[section] = tagListSectionModel
            }
        }
        //
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            // header
            if let sectionModel = sectionModels[section] {
                let headerSection = IndexPath(item: 0, section: section)
                _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerSection)
                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                if let attr = sectionModel.headerLayoutAttributes {
                    var frame = attr.frame
                    if scrollDirection == .vertical {
                        frame.origin.y = beforeSectionTotalLength
                        if sectionModel.sectionInsetContainHeader {
                            frame.origin.x = sectionModel.sectionInset.left
                            frame.origin.y += sectionModel.sectionInset.top
                            frame.size.width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
                        }
                    } else if scrollDirection == .horizontal {
                        frame.origin.x = beforeSectionTotalLength
                        if sectionModel.sectionInsetContainHeader {
                            frame.origin.x += sectionModel.sectionInset.left
                            frame.origin.y = sectionModel.sectionInset.top
                            frame.size.height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
                        }
                    }
                    attr.frame = frame // update header frame
                }
            }
            // item
            if let sectionModel = sectionModels[section] {
                switch sectionModel.sectionType {
                    case .normal:
                        for index in 0..<numberOfItems {
                            let itemIndexPath = IndexPath(item: index, section: section)
                            _layoutNormalAttributesForItem(at: itemIndexPath)
                        }
                    case .waterFlow:
                        for index in 0..<numberOfItems {
                            let itemIndexPath = IndexPath(item: index, section: section)
                            _layoutWaterFlowAttributesForItem(at: itemIndexPath)
                        }
                    case .tagList:
                        for index in 0..<numberOfItems {
                            let itemIndexPath = IndexPath(item: index, section: section)
                            _layoutNormalAttributesForItem(at: itemIndexPath)
                        }
                        _layoutTagListAttributesForItem(at: section)
                }
                if sectionModel.sectionType != .normal {
                    let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                    for attr in sectionModel.itemLayoutAttributes {
                        var frame = attr.frame
                        if scrollDirection == .vertical {
                            frame.origin.y += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
                        } else if scrollDirection == .horizontal {
                            frame.origin.x += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
                        }
                        attr.frame = frame // update item frame
                    }
                }
            }
            // footer
            if let sectionModel = sectionModels[section] {
                let footerSection = IndexPath(item: 0, section: section)
                _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerSection)
                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
                if let attr = sectionModel.footerLayoutAttributes {
                    var frame = attr.frame
                    if scrollDirection == .vertical {
                        frame.origin.y = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                        if sectionModel.sectionInsetContainFooter {
                            frame.origin.x = sectionModel.sectionInset.left
                            frame.origin.y -= sectionModel.sectionInset.bottom
                            frame.size.width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
                        }
                    } else if scrollDirection == .horizontal {
                        frame.origin.x = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                        if sectionModel.sectionInsetContainFooter {
                            frame.origin.x -= sectionModel.sectionInset.right
                            frame.origin.y = sectionModel.sectionInset.top
                            frame.size.height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
                        }
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
            //
            if let attr = section.headerLayoutAttributes {
                elements.append(attr)
            }
            //
            elements.append(contentsOf: section.itemLayoutAttributes)
            //
            if let attr = section.footerLayoutAttributes {
                elements.append(attr)
            }
        }
        return elements
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
        switch scrollDirection {
            case .vertical:
                return CGSize(width: collectionView.bounds.width, height: totalLength)
            case .horizontal:
                return CGSize(width: totalLength, height: collectionView.bounds.height)
            @unknown default:
                return super.collectionViewContentSize
        }
    }
}

extension SwiftyCollectionViewFlowLayout {
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
