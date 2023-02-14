//
//  ModeState+Pinned.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/14.
//

import Foundation
import UIKit

extension ModeState {
    internal func pinned(sectionModel: SectionModel, section: Int) {
        guard let layout = layout else { return }
        
        let offsetX = layout.mCollectionView.contentOffset.x
        let offsetY = layout.mCollectionView.contentOffset.y
        
//        var sectionFrame: CGRect = .zero
//        if let header = sectionModel.headerModel {
//            sectionFrame = header.frame
//        }
//        if !sectionModel.itemModels.isEmpty {
//            sectionFrame = sectionModel.itemModels.first!.frame
//            sectionFrame = sectionModel.itemModels.reduce(sectionFrame, { $0.union($1.frame) })
//        }
//        if let footer = sectionModel.footerModel {
//            if sectionFrame == .zero {
//                sectionFrame = footer.frame
//            } else {
//                sectionFrame = sectionFrame.union(footer.frame)
//            }
//        }
        
//        if let header = sectionModel.headerModel {
//            var bottomY: CGFloat
//            if let footer = sectionModel.footerModel {
//                bottomY = footer.frame.origin.y
//            } else if !sectionModel.itemModels.isEmpty {
//                var allItemFrame = sectionModel.itemModels.first!.frame
//                allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
//                bottomY = allItemFrame.maxY
//                bottomY += sectionModel.metrics.sectionInset.bottom
//            } else {
//                bottomY = header.frame.maxY
//                bottomY += sectionModel.metrics.sectionInset.bottom
//            }
//
//            var headerFrame = header.frame
//            if offsetY >= headerFrame.origin.y && offsetY <= bottomY - headerFrame.height {
//                headerFrame.origin.y = offsetY
//            } else if offsetY > bottomY - headerFrame.height && offsetY <= bottomY {
//                headerFrame.origin.y = bottomY - headerFrame.height
//            }
//            header.pinnedFrame = headerFrame
//        }
        
        
        if let footer = sectionModel.footerModel {
            
//            var newTopY: CGFloat?
//            if let header = sectionModel.headerModel {
//                newTopY = header.frame.maxY
//            } else if !sectionModel.itemModels.isEmpty {
//                var allItemFrame = sectionModel.itemModels.first!.frame
//                allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
//                var _topY = allItemFrame.minY
//                _topY -= sectionModel.metrics.sectionInset.top
//                newTopY = _topY
//            }
//
//            if newTopY != nil {
//                if newTopY! > offsetY + layout.mCollectionView.bounds.height - footer.frame.height &&
//                    newTopY! <= offsetY + layout.mCollectionView.bounds.height {
//
//                    footerFrame.origin.y = newTopY!
//                }
//            }
            
            var pinBottomOriginY = offsetY + layout.mCollectionView.bounds.height - footer.frame.height
            
            
            var topY: CGFloat?
            if let header = sectionModel.headerModel {
                topY = header.frame.maxY
            } else if !sectionModel.itemModels.isEmpty {
                var allItemFrame = sectionModel.itemModels.first!.frame
                allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
                var _topY = allItemFrame.minY
                _topY -= sectionModel.metrics.sectionInset.top
                topY = _topY
            }
            if topY != nil {
                var footerFrame = footer.frame
                
//                if offsetY <= footer.frame.minY - layout.mCollectionView.bounds.height {
//                    footerFrame.origin.y = offsetY + layout.mCollectionView.bounds.height - footer.frame.height
//                } else {
                    if topY! <= pinBottomOriginY {
                        footerFrame.origin.y = pinBottomOriginY
                    } else if topY! > pinBottomOriginY && topY! <= pinBottomOriginY + footer.frame.height {
                        footerFrame.origin.y = topY!
                    }
//                }
                
                
                
//                if offsetY >= topY! && offsetY <= footer.frame.maxY - layout.mCollectionView.bounds.height {
                    
//                    footerFrame.origin.y = offsetY + layout.mCollectionView.bounds.height - footer.frame.height
                    
//                } else {
                    
//                    var newTopY: CGFloat?
//                    if let header = sectionModel.headerModel {
//                        newTopY = header.frame.minY
//                    } else if !sectionModel.itemModels.isEmpty {
//                        var allItemFrame = sectionModel.itemModels.first!.frame
//                        allItemFrame = sectionModel.itemModels.reduce(allItemFrame, { $0.union($1.frame) })
//                        var _topY = allItemFrame.minY
//                        _topY -= sectionModel.metrics.sectionInset.top
//                        newTopY = _topY
//                    }
//
//                    if newTopY != nil {
//                        if newTopY! > offsetY + layout.mCollectionView.bounds.height - footer.frame.height &&
//                            newTopY! <= offsetY + layout.mCollectionView.bounds.height {
//
//                            footerFrame.origin.y = newTopY!
//                        }
//                    }
//                }
                
                footer.pinnedFrame = footerFrame
            }
        }
    }
}
