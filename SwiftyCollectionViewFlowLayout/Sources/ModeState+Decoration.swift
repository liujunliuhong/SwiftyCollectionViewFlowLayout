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
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let decorationModel = decorationModel(at: section) else { return }
        
        let scrollDirection = layout.scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = decorationModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.x = sectionModel.metrics.sectionInset.left
                frame.size.width = layout.mCollectionView.bounds.width - sectionModel.metrics.sectionInset.left - sectionModel.metrics.sectionInset.right
                
                if let headerModel = sectionModel.headerModel, sectionModel.metrics.sectionInsetContainHeader {
                    frame.origin.y = previousSectionTotalLength + sectionModel.metrics.sectionInset.top
                    frame.size.height = sectionModel.allItemsLength(scrollDirection: scrollDirection) + headerModel.frame.height
                } else {
                    frame.origin.y = previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    frame.size.height = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                }
                
                if let footerModel = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    frame.size.height += footerModel.frame.height
                }
                
                frame.origin.x -= decorationModel.extraInset.left
                frame.origin.y -= decorationModel.extraInset.top
                frame.size.width += (decorationModel.extraInset.left + decorationModel.extraInset.right)
                frame.size.height += (decorationModel.extraInset.top + decorationModel.extraInset.bottom)
                
            case .horizontal:
                frame.origin.y = sectionModel.metrics.sectionInset.top
                frame.size.height = layout.mCollectionView.bounds.height - sectionModel.metrics.sectionInset.top - sectionModel.metrics.sectionInset.bottom
                
                if let headerModel = sectionModel.headerModel, sectionModel.metrics.sectionInsetContainHeader {
                    frame.origin.x = previousSectionTotalLength + sectionModel.metrics.sectionInset.left
                    frame.size.width = sectionModel.allItemsLength(scrollDirection: scrollDirection) + headerModel.frame.width
                } else {
                    frame.origin.x = previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                    frame.size.width = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                }
                
                if let footerModel = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    frame.size.width += footerModel.frame.width
                }
                
                frame.origin.x -= decorationModel.extraInset.left
                frame.origin.y -= decorationModel.extraInset.top
                frame.size.width += (decorationModel.extraInset.left + decorationModel.extraInset.right)
                frame.size.height += (decorationModel.extraInset.top + decorationModel.extraInset.bottom)
            default:
                break
        }
        decorationModel.frame = frame
    }
    
    internal func decorationLayoutAttributes(at section: Int, frame: CGRect) -> UICollectionViewLayoutAttributes {
        let extraAttributes = decorationModel(at: section)?.extraAttributes
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutDecorationAttributes(forDecorationViewOfKind: SwiftyCollectionViewFlowLayout.DecorationElementKind, with: indexPath)
        attr.extraAttributes = extraAttributes
        attr.frame = frame
        attr.zIndex = -999
        return attr
    }
}
