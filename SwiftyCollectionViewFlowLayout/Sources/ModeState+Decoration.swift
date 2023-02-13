//
//  ModeState+Decoration.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/8.
//

import Foundation
import UIKit

extension ModeState {
    internal func layoutDecorationModel(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let decorationModel = decorationModel(at: section) else { return }
        
        guard let layout = layout else { return }
        
        let scrollDirection = layout.scrollDirection
        
        var standardDecorationFrame: CGRect = .zero
        switch scrollDirection {
            case .vertical:
                if let header = sectionModel.headerModel, sectionModel.metrics.sectionInsetContainHeader {
                    standardDecorationFrame.origin.x = sectionModel.metrics.sectionInset.left
                    
                    standardDecorationFrame.origin.y = previousSectionTotalLength(currentSection: section)
                    standardDecorationFrame.origin.y += sectionModel.metrics.sectionInset.top
                    
                    standardDecorationFrame.size.width = layout.mCollectionView.bounds.width - sectionModel.metrics.sectionInset.left - sectionModel.metrics.sectionInset.right
                    
                    standardDecorationFrame.size.height = header.frame.height
                    standardDecorationFrame.size.height += sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        standardDecorationFrame.size.height += footer.frame.height
                    }
                } else {
                    standardDecorationFrame.origin.x = sectionModel.metrics.sectionInset.left
                    
                    standardDecorationFrame.origin.y = previousSectionTotalLength(currentSection: section) + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    
                    standardDecorationFrame.size.width = layout.mCollectionView.bounds.width - sectionModel.metrics.sectionInset.left - sectionModel.metrics.sectionInset.right
                    
                    standardDecorationFrame.size.height = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        standardDecorationFrame.size.height += footer.frame.height
                    }
                }
            case .horizontal:
                if let header = sectionModel.headerModel, sectionModel.metrics.sectionInsetContainHeader {
                    standardDecorationFrame.origin.x = previousSectionTotalLength(currentSection: section)
                    standardDecorationFrame.origin.x += sectionModel.metrics.sectionInset.left
                    
                    standardDecorationFrame.origin.y = sectionModel.metrics.sectionInset.top
                    
                    standardDecorationFrame.size.height = layout.mCollectionView.bounds.height - sectionModel.metrics.sectionInset.top - sectionModel.metrics.sectionInset.bottom
                    
                    standardDecorationFrame.size.width = header.frame.width
                    standardDecorationFrame.size.width += sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        standardDecorationFrame.size.width += footer.frame.width
                    }
                } else {
                    standardDecorationFrame.origin.x = previousSectionTotalLength(currentSection: section) + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    
                    standardDecorationFrame.origin.y = sectionModel.metrics.sectionInset.top
                    
                    standardDecorationFrame.size.height = layout.mCollectionView.bounds.height - sectionModel.metrics.sectionInset.top - sectionModel.metrics.sectionInset.bottom
                    
                    standardDecorationFrame.size.width = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        standardDecorationFrame.size.width += footer.frame.width
                    }
                }
            default:
                break
        }
        
        
        var compactDecorationFrame: CGRect = .zero
        if let header = sectionModel.headerModel {
            if sectionModel.metrics.sectionInsetContainHeader {
                compactDecorationFrame = header.frame
                compactDecorationFrame = sectionModel.itemModels.reduce(compactDecorationFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    compactDecorationFrame = compactDecorationFrame.union(footer.frame)
                }
            } else {
                if sectionModel.itemModels.isEmpty {
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        compactDecorationFrame = footer.frame
                    }
                } else {
                    compactDecorationFrame = sectionModel.itemModels.first!.frame
                    compactDecorationFrame = sectionModel.itemModels.reduce(compactDecorationFrame, { $0.union($1.frame) })
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        compactDecorationFrame = compactDecorationFrame.union(footer.frame)
                    }
                }
            }
        } else {
            if sectionModel.itemModels.isEmpty {
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    compactDecorationFrame = footer.frame
                }
            } else {
                compactDecorationFrame = sectionModel.itemModels.first!.frame
                compactDecorationFrame = sectionModel.itemModels.reduce(compactDecorationFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    compactDecorationFrame = compactDecorationFrame.union(footer.frame)
                }
            }
        }
        
        var finalFrame: CGRect = .zero
        if standardDecorationFrame == .zero && compactDecorationFrame != .zero {
            finalFrame = compactDecorationFrame
        } else if standardDecorationFrame != .zero && compactDecorationFrame == .zero {
            finalFrame = standardDecorationFrame
        } else if standardDecorationFrame != .zero && compactDecorationFrame != .zero {
            finalFrame = standardDecorationFrame.union(compactDecorationFrame)
        }
        
        finalFrame.origin.x -= decorationModel.extraInset.left
        finalFrame.origin.y -= decorationModel.extraInset.top
        finalFrame.size.width += (decorationModel.extraInset.left + decorationModel.extraInset.right)
        finalFrame.size.height += (decorationModel.extraInset.top + decorationModel.extraInset.bottom)
        
        decorationModel.frame = finalFrame
    }
    
    internal func decorationLayoutAttributes(at section: Int, frame: CGRect) -> UICollectionViewLayoutAttributes {
        let extraAttributes = decorationModel(at: section)?.extraAttributes
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewDecorationAttributes(forDecorationViewOfKind: SwiftyCollectionViewFlowLayout.DecorationElementKind, with: indexPath)
        attr.extraAttributes = extraAttributes
        attr.frame = frame
        attr.zIndex = -999
        return attr
    }
}
