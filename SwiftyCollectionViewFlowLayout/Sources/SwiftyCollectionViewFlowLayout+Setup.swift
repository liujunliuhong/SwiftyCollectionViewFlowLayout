//
//  SwiftyCollectionViewFlowLayout+Setup.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation
import UIKit


//extension SwiftyCollectionViewFlowLayout {
//    internal func _prepare() {
//        //
//        guard let collectionView = collectionView else { return }
//        //
//        let numberOfSections = collectionView.numberOfSections
//        // Basic Info
//        for section in 0..<numberOfSections {
//            let indexPath = IndexPath(item: 0, section: section)
//            
//            let sectionInset = mDelegate?.collectionView(collectionView,
//                                                         layout: self,
//                                                         insetForSectionAt: section) ?? Default.sectionInset
//            
//            let sectionInsetContainHeader = mDelegate?.collectionView(collectionView,
//                                                                      layout: self,
//                                                                      sectionInsetContainHeader: indexPath.section) ?? Default.sectionInsetContainHeader
//            
//            let sectionInsetContainFooter = mDelegate?.collectionView(collectionView,
//                                                                      layout: self,
//                                                                      sectionInsetContainFooter: indexPath.section) ?? Default.sectionInsetContainFooter
//            
//            let lineSpacing = mDelegate?.collectionView(collectionView,
//                                                        layout: self,
//                                                        minimumLineSpacingForSectionAt: section) ?? Default.minimumLineSpacing
//            
//            let interitemSpacing = mDelegate?.collectionView(collectionView,
//                                                             layout: self,
//                                                             minimumInteritemSpacingForSectionAt: section) ?? Default.minimumInteritemSpacing
//            
//            let sectionType = mDelegate?.collectionView(collectionView,
//                                                        layout: self,
//                                                        sectionType: section) ?? Default.sectionType
//            
//            switch sectionType {
//                case .waterFlow(let numberOfColumns):
//                    var bodyColumnLengths: [CGFloat] = []
//                    for _ in 0..<numberOfColumns {
//                        bodyColumnLengths.append(.zero)
//                    }
//                    let waterFlowSectionModel = WaterFlowSectionModel()
//                    waterFlowSectionModel.sectionInset = sectionInset
//                    waterFlowSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
//                    waterFlowSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
//                    waterFlowSectionModel.lineSpacing = lineSpacing
//                    waterFlowSectionModel.interitemSpacing = interitemSpacing
//                    waterFlowSectionModel.sectionType = sectionType
//                    
//                    waterFlowSectionModel.bodyColumnLengths = bodyColumnLengths
//                    
//                    sectionModels[section] = waterFlowSectionModel
//                case .tagList:
//                    let tagListSectionModel = TagListSectionModel()
//                    tagListSectionModel.sectionInset = sectionInset
//                    tagListSectionModel.sectionInsetContainHeader = sectionInsetContainHeader
//                    tagListSectionModel.sectionInsetContainFooter = sectionInsetContainFooter
//                    tagListSectionModel.lineSpacing = lineSpacing
//                    tagListSectionModel.interitemSpacing = interitemSpacing
//                    tagListSectionModel.sectionType = sectionType
//                    sectionModels[section] = tagListSectionModel
//            }
//        }
//    }
//    
//    internal func _layout() {
//        guard let collectionView = collectionView else { return }
//        //
//        let numberOfSections = collectionView.numberOfSections
//        //
//        for section in 0..<numberOfSections {
//            let numberOfItems = collectionView.numberOfItems(inSection: section)
//            // header
//            if let sectionModel = sectionModels[section] {
//                let headerSection = IndexPath(item: 0, section: section)
//                _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerSection)
//                if let attr = sectionModel.headerLayoutAttributes {
//                    let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
//                    var frame = attr.frame
//                    if scrollDirection == .vertical {
//                        frame.origin.y = beforeSectionTotalLength
//                        if sectionModel.sectionInsetContainHeader {
//                            frame.origin.x = sectionModel.sectionInset.left
//                            frame.origin.y += sectionModel.sectionInset.top
//                            frame.size.width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
//                        }
//                    } else if scrollDirection == .horizontal {
//                        frame.origin.x = beforeSectionTotalLength
//                        if sectionModel.sectionInsetContainHeader {
//                            frame.origin.x += sectionModel.sectionInset.left
//                            frame.origin.y = sectionModel.sectionInset.top
//                            frame.size.height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
//                        }
//                    }
//                    attr.frame = frame // update header frame
//                }
//            }
//            // item
//            if let sectionModel = sectionModels[section] {
//                switch sectionModel.sectionType {
//                    case .waterFlow:
//                        _layoutWaterFlowAttributesForItem(at: section)
//                    case .tagList:
//                        _layoutTagListAttributesForItem(at: section)
//                }
//                let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
//                for attr in sectionModel.itemLayoutAttributes {
//                    var frame = attr.frame
//                    if scrollDirection == .vertical {
//                        frame.origin.y += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
//                    } else if scrollDirection == .horizontal {
//                        frame.origin.x += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
//                    }
//                    attr.frame = frame // update item frame
//                }
//            }
//            // footer
//            if let sectionModel = sectionModels[section] {
//                let footerSection = IndexPath(item: 0, section: section)
//                _layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerSection)
//                if let attr = sectionModel.footerLayoutAttributes {
//                    let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
//                    var frame = attr.frame
//                    if scrollDirection == .vertical {
//                        frame.origin.y = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
//                        if sectionModel.sectionInsetContainFooter {
//                            frame.origin.x = sectionModel.sectionInset.left
//                            frame.origin.y -= sectionModel.sectionInset.bottom
//                            frame.size.width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
//                        }
//                    } else if scrollDirection == .horizontal {
//                        frame.origin.x = beforeSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
//                        if sectionModel.sectionInsetContainFooter {
//                            frame.origin.x -= sectionModel.sectionInset.right
//                            frame.origin.y = sectionModel.sectionInset.top
//                            frame.size.height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
//                        }
//                    }
//                    attr.frame = frame // update footer frame
//                }
//            }
//            // decoration
//            if let sectionModel = sectionModels[section] {
//                let decorationSection = IndexPath(item: 0, section: section)
//                _layoutGroupDecorationAttributesForItem(at: decorationSection)
//                if let attr = sectionModel.groupDecorationAttributes {
//                    let decorationExtraInset = mDelegate?.collectionView(collectionView, layout: self, decorationExtraInset: section) ?? Default.decorationExtraInset
//                    
//                    let beforeSectionTotalLength = getBeforeSectionTotalLength(currentSection: section)
//                    
//                    var frame = attr.frame
//                    
//                    if scrollDirection == .vertical {
//                        if let headerAttr = sectionModel.headerLayoutAttributes, sectionModel.sectionInsetContainHeader {
//                            frame.origin.y = headerAttr.frame.origin.y
//                            frame.size.height += headerAttr.frame.height
//                        } else {
//                            frame.origin.y += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
//                        }
//                        
//                        if let footerAttr = sectionModel.footerLayoutAttributes, sectionModel.sectionInsetContainFooter {
//                            frame.size.height += footerAttr.frame.height
//                        }
//                        
//                        frame.origin.x -= decorationExtraInset.left
//                        frame.origin.y -= decorationExtraInset.top
//                        frame.size.width += (decorationExtraInset.left + decorationExtraInset.right)
//                        frame.size.height += (decorationExtraInset.top + decorationExtraInset.bottom)
//                        
//                    } else if scrollDirection == .horizontal {
//                        if let headerAttr = sectionModel.headerLayoutAttributes, sectionModel.sectionInsetContainHeader {
//                            frame.origin.x = headerAttr.frame.origin.x
//                            frame.size.width += headerAttr.frame.width
//                        } else {
//                            frame.origin.x += (beforeSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
//                        }
//                        
//                        if let footerAttr = sectionModel.footerLayoutAttributes, sectionModel.sectionInsetContainFooter {
//                            frame.size.width += footerAttr.frame.width
//                        }
//                        
//                        frame.origin.x -= decorationExtraInset.left
//                        frame.origin.y -= decorationExtraInset.top
//                        frame.size.width += (decorationExtraInset.left + decorationExtraInset.right)
//                        frame.size.height += (decorationExtraInset.top + decorationExtraInset.bottom)
//                    }
//                    attr.zIndex = -999
//                    attr.frame = frame // update decoration frame
//                }
//            }
//        }
//    }
//}
