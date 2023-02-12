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
        
        var decorationFrame: CGRect = .zero
        
        if let header = sectionModel.headerModel {
            if sectionModel.metrics.sectionInsetContainHeader {
                decorationFrame = header.frame
                decorationFrame = sectionModel.itemModels.reduce(decorationFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    decorationFrame = decorationFrame.union(footer.frame)
                }
            } else {
                if sectionModel.itemModels.isEmpty {
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        decorationFrame = footer.frame
                    }
                } else {
                    decorationFrame = sectionModel.itemModels.first!.frame
                    decorationFrame = sectionModel.itemModels.reduce(decorationFrame, { $0.union($1.frame) })
                    if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                        decorationFrame = decorationFrame.union(footer.frame)
                    }
                }
            }
        } else {
            if sectionModel.itemModels.isEmpty {
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    decorationFrame = footer.frame
                }
            } else {
                decorationFrame = sectionModel.itemModels.first!.frame
                decorationFrame = sectionModel.itemModels.reduce(decorationFrame, { $0.union($1.frame) })
                if let footer = sectionModel.footerModel, sectionModel.metrics.sectionInsetContainFooter {
                    decorationFrame = decorationFrame.union(footer.frame)
                }
            }
        }
        
        decorationFrame.origin.x -= decorationModel.extraInset.left
        decorationFrame.origin.y -= decorationModel.extraInset.top
        decorationFrame.size.width += (decorationModel.extraInset.left + decorationModel.extraInset.right)
        decorationFrame.size.height += (decorationModel.extraInset.top + decorationModel.extraInset.bottom)
        
        decorationModel.frame = decorationFrame
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
