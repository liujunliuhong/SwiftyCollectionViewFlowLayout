//
//  ModeState+Background.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/13.
//

import Foundation
import UIKit

extension ModeState {
    internal func layoutBackgroundModel(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let backgroundModel = sectionModel.backgroundModel else { return }
        
        let metrics = sectionModel.metrics
        
        var standardBackgroundFrame: CGRect = .zero
        switch scrollDirection {
            case .vertical:
                if let header = sectionModel.headerModel, metrics.sectionInsetContainHeader {
                    standardBackgroundFrame.origin.x = metrics.sectionInset.left
                    
                    standardBackgroundFrame.origin.y = previousSectionTotalLength(currentSection: section)
                    standardBackgroundFrame.origin.y += metrics.sectionInset.top
                    
                    standardBackgroundFrame.size.width = collectionViewSize.width - metrics.sectionInset.left - metrics.sectionInset.right
                    
                    standardBackgroundFrame.size.height = header.frame.height
                    standardBackgroundFrame.size.height += sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        standardBackgroundFrame.size.height += footer.frame.height
                    }
                } else {
                    standardBackgroundFrame.origin.x = metrics.sectionInset.left
                    
                    standardBackgroundFrame.origin.y = previousSectionTotalLength(currentSection: section) + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    
                    standardBackgroundFrame.size.width = collectionViewSize.width - metrics.sectionInset.left - metrics.sectionInset.right
                    
                    standardBackgroundFrame.size.height = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        standardBackgroundFrame.size.height += footer.frame.height
                    }
                }
            case .horizontal:
                if let header = sectionModel.headerModel, metrics.sectionInsetContainHeader {
                    standardBackgroundFrame.origin.x = previousSectionTotalLength(currentSection: section)
                    standardBackgroundFrame.origin.x += metrics.sectionInset.left
                    
                    standardBackgroundFrame.origin.y = metrics.sectionInset.top
                    
                    standardBackgroundFrame.size.height = collectionViewSize.height - metrics.sectionInset.top - metrics.sectionInset.bottom
                    
                    standardBackgroundFrame.size.width = header.frame.width
                    standardBackgroundFrame.size.width += sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        standardBackgroundFrame.size.width += footer.frame.width
                    }
                } else {
                    standardBackgroundFrame.origin.x = previousSectionTotalLength(currentSection: section) + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    
                    standardBackgroundFrame.origin.y = metrics.sectionInset.top
                    
                    standardBackgroundFrame.size.height = collectionViewSize.height - metrics.sectionInset.top - metrics.sectionInset.bottom
                    
                    standardBackgroundFrame.size.width = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        standardBackgroundFrame.size.width += footer.frame.width
                    }
                }
            default:
                break
        }
        
        
        var compactBackgroundFrame: CGRect = .zero
        if let header = sectionModel.headerModel {
            if metrics.sectionInsetContainHeader {
                compactBackgroundFrame = header.frame
                compactBackgroundFrame = sectionModel.itemModels.reduce(compactBackgroundFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                    compactBackgroundFrame = compactBackgroundFrame.union(footer.frame)
                }
            } else {
                if sectionModel.itemModels.isEmpty {
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        compactBackgroundFrame = footer.frame
                    }
                } else {
                    compactBackgroundFrame = sectionModel.itemModels.first!.frame
                    compactBackgroundFrame = sectionModel.itemModels.reduce(compactBackgroundFrame, { $0.union($1.frame) })
                    if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                        compactBackgroundFrame = compactBackgroundFrame.union(footer.frame)
                    }
                }
            }
        } else {
            if sectionModel.itemModels.isEmpty {
                if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                    compactBackgroundFrame = footer.frame
                }
            } else {
                compactBackgroundFrame = sectionModel.itemModels.first!.frame
                compactBackgroundFrame = sectionModel.itemModels.reduce(compactBackgroundFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, metrics.sectionInsetContainFooter {
                    compactBackgroundFrame = compactBackgroundFrame.union(footer.frame)
                }
            }
        }
        
        var finalFrame: CGRect = .zero
        if standardBackgroundFrame == .zero && compactBackgroundFrame != .zero {
            finalFrame = compactBackgroundFrame
        } else if standardBackgroundFrame != .zero && compactBackgroundFrame == .zero {
            finalFrame = standardBackgroundFrame
        } else if standardBackgroundFrame != .zero && compactBackgroundFrame != .zero {
            finalFrame = standardBackgroundFrame.union(compactBackgroundFrame)
        }
        
        finalFrame.origin.x -= metrics.backgroundInset.left
        finalFrame.origin.y -= metrics.backgroundInset.top
        finalFrame.size.width += (metrics.backgroundInset.left + metrics.backgroundInset.right)
        finalFrame.size.height += (metrics.backgroundInset.top + metrics.backgroundInset.bottom)
        
        backgroundModel.frame = finalFrame
    }
    
    internal func backgroundLayoutAttributes(at section: Int, frame: CGRect) -> SwiftyCollectionViewLayoutAttributes {
        var attr: SwiftyCollectionViewLayoutAttributes
        if let cachedAttr = getCachedBackground(at: section) {
            attr = cachedAttr
        } else {
            let indexPath = IndexPath(item: 0, section: section)
            attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, with: indexPath)
        }
        attr.frame = frame
        attr.zIndex = -999
        return attr
    }
}


