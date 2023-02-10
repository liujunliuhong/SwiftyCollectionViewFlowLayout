//
//  SectionModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

internal final class SectionModel {
    internal let sectionType: SwiftyCollectionViewSectionType
    internal var headerModel: HeaderModel?
    internal var footerModel: FooterModel?
    internal var itemModels: [ItemModel]
    internal var decorationModel: DecorationModel?
    
    internal let sectionInset: UIEdgeInsets
    internal let lineSpacing: CGFloat
    internal let interitemSpacing: CGFloat
    internal let sectionInsetContainHeader: Bool
    internal let sectionInsetContainFooter: Bool
    
    internal init(sectionType: SwiftyCollectionViewSectionType,
                  headerModel: HeaderModel?,
                  footerModel: FooterModel?,
                  itemModels: [ItemModel],
                  decorationModel: DecorationModel?,
                  sectionInset: UIEdgeInsets,
                  lineSpacing: CGFloat,
                  interitemSpacing: CGFloat,
                  sectionInsetContainHeader: Bool,
                  sectionInsetContainFooter: Bool) {
        self.sectionType = sectionType
        self.headerModel = headerModel
        self.footerModel = footerModel
        self.itemModels = itemModels
        self.decorationModel = decorationModel
        self.sectionInset = sectionInset
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
        self.sectionInsetContainHeader = sectionInsetContainHeader
        self.sectionInsetContainFooter = sectionInsetContainFooter
    }
}

extension SectionModel {
    /// 当前Section中所有Item的总长度
    internal func allItemsLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            if !itemModels.isEmpty {
                let allItemFrame = itemModels.reduce(itemModels.first!.frame) { partialResult, item in
                    return partialResult.union(item.frame)
                }
                length += allItemFrame.height
            }
        } else {
            if !itemModels.isEmpty {
                let allItemFrame = itemModels.reduce(itemModels.first!.frame) { partialResult, item in
                    return partialResult.union(item.frame)
                }
                length += allItemFrame.width
            }
        }
        return length
    }
    
    
    /// 当前Section总长度
    internal func totalLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.height
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.bottom
            // footer
            if let footerModel = footerModel {
                length += footerModel.frame.height
            }
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.width
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.right
            // footer
            if let footerModel = footerModel {
                length += footerModel.frame.width
            }
        }
        return length
    }
    
    // 当前Section的Body之前的长度(header + sectionInset.top)
    internal func bodyBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.height
            }
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.width
            }
        }
        return length
    }
    
    /// 当前Section的Footer之前的长度(header + sectionInset.top + body + sectionInset.bottom)
    internal func footerBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.height
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.bottom
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerModel = headerModel {
                length += headerModel.frame.width
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.right
        }
        return length
    }
}

extension SectionModel {
    @discardableResult
    internal func deleteItemModel(atIndex indexOfDeletion: Int) -> ItemModel {
        return itemModels.remove(at: indexOfDeletion)
    }
    
    internal func insert(_ itemModel: ItemModel, atIndex indexOfInsertion: Int) {
        itemModels.insert(itemModel, at: indexOfInsertion)
    }
}
