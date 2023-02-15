//
//  ModeState+Pinned.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/14.
//

import Foundation
import UIKit

extension ModeState {
    internal func pinned(at section: Int) {
        guard let layout = layout else { return }
        guard let sectionModel = self.sectionModel(at: section) else { return }
        
        let offsetX = layout.mCollectionView.contentOffset.x
        let offsetY = layout.mCollectionView.contentOffset.y
        
        switch layout.scrollDirection {
            case .vertical:
                if let header = sectionModel.headerModel, sectionModel.metrics.headerPinToVisibleBounds {
                    var bottomY: CGFloat
                    if let footer = sectionModel.footerModel {
                        bottomY = footer.frame.origin.y
                    } else if !sectionModel.itemModels.isEmpty {
                        var allItemFrame = sectionModel.itemModels.first!.frame
                        allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
                        var _bottomY = allItemFrame.maxY
                        _bottomY += sectionModel.metrics.sectionInset.bottom
                        bottomY = _bottomY
                    } else {
                        bottomY = header.frame.maxY + sectionModel.metrics.sectionInset.top + sectionModel.metrics.sectionInset.bottom
                    }
                    
                    let pinTopOriginY = offsetY
                    
                    var headerFrame = header.frame
                    
                    if pinTopOriginY >= headerFrame.origin.y && pinTopOriginY <= bottomY - headerFrame.height {
                        headerFrame.origin.y = pinTopOriginY
                    } else if pinTopOriginY > bottomY - headerFrame.height && pinTopOriginY <= bottomY {
                        headerFrame.origin.y = bottomY - headerFrame.height
                    }
                    header.pinnedFrame = headerFrame
                }
                if let footer = sectionModel.footerModel, sectionModel.metrics.footerPinToVisibleBounds {
                    var topY: CGFloat
                    if let header = sectionModel.headerModel {
                        topY = header.frame.maxY
                    } else if !sectionModel.itemModels.isEmpty {
                        var allItemFrame = sectionModel.itemModels.first!.frame
                        allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
                        var _topY = allItemFrame.minY
                        _topY -= sectionModel.metrics.sectionInset.top
                        topY = _topY
                    } else {
                        topY = previousSectionTotalLength(currentSection: section)
                    }
                    
                    let pinBottomOriginY = offsetY + layout.mCollectionView.bounds.height - footer.frame.height
                    
                    var footerFrame = footer.frame
                    
                    if topY <= pinBottomOriginY && pinBottomOriginY <= footer.frame.origin.y {
                        footerFrame.origin.y = pinBottomOriginY
                    } else if topY > pinBottomOriginY && topY <= pinBottomOriginY + footer.frame.height {
                        footerFrame.origin.y = topY
                    }
                    
                    footer.pinnedFrame = footerFrame
                    
                }
            case .horizontal:
                if let header = sectionModel.headerModel, sectionModel.metrics.headerPinToVisibleBounds {
                    var bottomX: CGFloat
                    if let footer = sectionModel.footerModel {
                        bottomX = footer.frame.origin.x
                    } else if !sectionModel.itemModels.isEmpty {
                        var allItemFrame = sectionModel.itemModels.first!.frame
                        allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
                        var _bottomX = allItemFrame.maxX
                        _bottomX += sectionModel.metrics.sectionInset.right
                        bottomX = _bottomX
                    } else {
                        bottomX = header.frame.maxX + sectionModel.metrics.sectionInset.left + sectionModel.metrics.sectionInset.right
                    }
                    
                    let pinTopOriginX = offsetX
                    
                    var headerFrame = header.frame
                    
                    if pinTopOriginX >= headerFrame.origin.x && pinTopOriginX <= bottomX - headerFrame.width {
                        headerFrame.origin.x = pinTopOriginX
                    } else if pinTopOriginX > bottomX - headerFrame.width && pinTopOriginX <= bottomX {
                        headerFrame.origin.x = bottomX - headerFrame.width
                    }
                    header.pinnedFrame = headerFrame
                }
                if let footer = sectionModel.footerModel, sectionModel.metrics.footerPinToVisibleBounds {
                    var topX: CGFloat
                    if let header = sectionModel.headerModel {
                        topX = header.frame.maxX
                    } else if !sectionModel.itemModels.isEmpty {
                        var allItemFrame = sectionModel.itemModels.first!.frame
                        allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
                        var _topX = allItemFrame.minX
                        _topX -= sectionModel.metrics.sectionInset.left
                        topX = _topX
                    } else {
                        topX = previousSectionTotalLength(currentSection: section)
                    }
                    
                    let pinBottomOriginX = offsetX + layout.mCollectionView.bounds.width - footer.frame.width
                    
                    var footerFrame = footer.frame
                    
                    if topX <= pinBottomOriginX && pinBottomOriginX <= footer.frame.origin.x {
                        footerFrame.origin.x = pinBottomOriginX
                    } else if topX > pinBottomOriginX && topX <= pinBottomOriginX + footer.frame.width {
                        footerFrame.origin.x = topX
                    }
                    
                    footer.pinnedFrame = footerFrame
                }
            default:
                break
        }
    }
}
