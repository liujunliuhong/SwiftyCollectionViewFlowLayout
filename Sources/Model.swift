//
//  Model.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/31.
//

import Foundation
import UIKit

internal class BaseSectionModel {
    var headerLayoutAttributes: UICollectionViewLayoutAttributes?
    var footerLayoutAttributes: UICollectionViewLayoutAttributes?
    var itemLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var sectionInset: UIEdgeInsets = .zero
    var lineSpacing: CGFloat = .zero
    var interitemSpacing: CGFloat = .zero
    var sectionInsetContainHeader: Bool = false
    var sectionInsetContainFooter: Bool = false
    
    var sectionType: SwiftyCollectionViewSectionType = .normal
}

extension BaseSectionModel {
    /// 当前Section中所有Item的总长度
    func allItemsLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.height
            }
        } else {
            if !itemLayoutAttributes.isEmpty {
                let allItemFrame = itemLayoutAttributes.reduce(itemLayoutAttributes.first!.frame) { partialResult, attr in
                    return partialResult.union(attr.frame)
                }
                length += allItemFrame.width
            }
        }
        return length
    }
    
    /// 当前Section总长度
    func totalLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.height
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.bottom
            // footer
            if let footerAttr = footerLayoutAttributes {
                length += footerAttr.frame.height
            }
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.width
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.right
            // footer
            if let footerAttr = footerLayoutAttributes {
                length += footerAttr.frame.width
            }
        }
        return length
    }
    
    func bodyBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.height
            }
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.width
            }
        }
        return length
    }
    
    // 当前Section的Footer之前的长度
    func footerBeforeLength(scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        var length: CGFloat = .zero
        if scrollDirection == .vertical {
            //
            length += sectionInset.top
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.height
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.bottom
        } else if scrollDirection == .horizontal {
            //
            length += sectionInset.left
            // header
            if let headerAttr = headerLayoutAttributes {
                length += headerAttr.frame.width
            }
            // items
            length += allItemsLength(scrollDirection: scrollDirection)
            //
            length += sectionInset.right
        }
        return length
    }
}


internal class NormalSectionModel: BaseSectionModel {
    
}


internal class WaterFlowSectionModel: BaseSectionModel {
    var bodyColumnLengths: [Int: CGFloat] = [:]
    
    /// 当前Section的Body总长度
    var maxBodyLength: CGFloat {
        var maxLength: CGFloat = .zero
        for length in bodyColumnLengths.values {
            if !length.isLessThanOrEqualTo(maxLength) {
                maxLength = length
            }
        }
        return maxLength
    }
    
    
    
    
}
