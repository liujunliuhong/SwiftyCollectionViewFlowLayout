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
        
        let scrollDirection = layout().scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = decorationModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.x = sectionModel.sectionInset.left
                frame.origin.y = .zero
                frame.size.width = layout().mCollectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
                frame.size.height = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                
                if let headerModel = sectionModel.headerModel, sectionModel.sectionInsetContainHeader {
                    frame.origin.y = headerModel.frame.origin.y
                    frame.size.height += headerModel.frame.height
                } else {
                    frame.origin.y = previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)
                }
                
                if let footerModel = sectionModel.footerModel, sectionModel.sectionInsetContainFooter {
                    frame.size.height += footerModel.frame.height
                }
                
                frame.origin.x -= decorationModel.extraInset.left
                frame.origin.y -= decorationModel.extraInset.top
                frame.size.width += (decorationModel.extraInset.left + decorationModel.extraInset.right)
                frame.size.height += (decorationModel.extraInset.top + decorationModel.extraInset.bottom)
                
            case .horizontal:
                frame.origin.x = .zero
                frame.origin.y = sectionModel.sectionInset.top
                frame.size.width = sectionModel.allItemsLength(scrollDirection: scrollDirection)
                frame.size.height = layout().mCollectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
                
                if let headerModel = sectionModel.headerModel, sectionModel.sectionInsetContainHeader {
                    frame.origin.x = headerModel.frame.origin.x
                    frame.size.width += headerModel.frame.width
                } else {
                    frame.origin.x += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
                }
                
                if let footerModel = sectionModel.footerModel, sectionModel.sectionInsetContainFooter {
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
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutDecorationAttributes(forDecorationViewOfKind: SwiftyCollectionViewFlowLayout.decorationElementKind, with: indexPath)
        attr.frame = frame
        attr.zIndex = -999
        return attr
    }
}
