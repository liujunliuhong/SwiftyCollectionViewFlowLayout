//
//  SectionModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

internal final class SectionModel {
    internal var headerModel: HeaderModel?
    internal var footerModel: FooterModel?
    internal var itemModels: [ItemModel]
    internal var backgroundModel: BackgroundModel?
    
    internal var metrics: SectionMetrics
    
    internal init(headerModel: HeaderModel?,
                  footerModel: FooterModel?,
                  itemModels: [ItemModel],
                  backgroundModel: BackgroundModel?,
                  metrics: SectionMetrics) {
        self.headerModel = headerModel
        self.footerModel = footerModel
        self.itemModels = itemModels
        self.backgroundModel = backgroundModel
        self.metrics = metrics
    }
}

extension SectionModel {
    /// 当前Section中所有Item的总长度
    internal func allItemsLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        switch scrollDirection {
            case .vertical:
                if !itemModels.isEmpty {
                    let allItemFrame = itemModels.reduce(itemModels.first!.frame) { partialResult, item in
                        return partialResult.union(item.frame)
                    }
                    length += allItemFrame.height
                }
            case .horizontal:
                if !itemModels.isEmpty {
                    let allItemFrame = itemModels.reduce(itemModels.first!.frame) { partialResult, item in
                        return partialResult.union(item.frame)
                    }
                    length += allItemFrame.width
                }
            default:
                break
        }
        return length
    }
    
    
    /// 当前Section总长度
    internal func totalLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        switch scrollDirection {
            case .vertical:
                //
                length += metrics.sectionInset.top
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.height
                }
                // items
                length += allItemsLength(scrollDirection: scrollDirection)
                //
                length += metrics.sectionInset.bottom
                // footer
                if let footerModel = footerModel {
                    length += footerModel.frame.height
                }
            case .horizontal:
                //
                length += metrics.sectionInset.left
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.width
                }
                // items
                length += allItemsLength(scrollDirection: scrollDirection)
                //
                length += metrics.sectionInset.right
                // footer
                if let footerModel = footerModel {
                    length += footerModel.frame.width
                }
            default:
                break
        }
        return length
    }
    
    // 当前Section的Body之前的长度(header + sectionInset.top)
    internal func bodyBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        switch scrollDirection {
            case .vertical:
                //
                length += metrics.sectionInset.top
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.height
                }
            case .horizontal:
                //
                length += metrics.sectionInset.left
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.width
                }
            default:
                break
        }
        return length
    }
    
    /// 当前Section的Footer之前的长度(header + sectionInset.top + body + sectionInset.bottom)
    internal func footerBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        switch scrollDirection {
            case .vertical:
                //
                length += metrics.sectionInset.top
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.height
                }
                // items
                length += allItemsLength(scrollDirection: scrollDirection)
                //
                length += metrics.sectionInset.bottom
            case .horizontal:
                //
                length += metrics.sectionInset.left
                // header
                if let headerModel = headerModel {
                    length += headerModel.frame.width
                }
                // items
                length += allItemsLength(scrollDirection: scrollDirection)
                //
                length += metrics.sectionInset.right
            default:
                break
        }
        return length
    }
}
