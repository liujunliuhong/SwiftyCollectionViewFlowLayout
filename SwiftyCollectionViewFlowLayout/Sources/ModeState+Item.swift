//
//  ModeState+Item.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

extension ModeState {
    internal func layoutItemModels(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        
        switch sectionModel.metrics.sectionType {
            case .waterFlow(let numberOfColumns):
                waterFlowLayout(sectionModel: sectionModel, numberOfColumns: numberOfColumns)
            case .row(let direction, let alignment):
                rowLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
        }
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        // update all items frame.origin.y or frame.origin.x
        for itemModel in sectionModel.itemModels {
            var frame = itemModel.frame
            switch scrollDirection {
                case .vertical:
                    frame.origin.y += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)) // update frame.origin.y
                case .horizontal:
                    frame.origin.x += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)) // update frame.origin.x
                default:
                    break
            }
            itemModel.frame = frame
        }
    }
    
    internal func itemLayoutAttributes(at indexPath: IndexPath,
                                       frame: CGRect,
                                       sectionModel: SectionModel,
                                       correctSizeMode: InternalSizeMode) -> SwiftyCollectionViewLayoutAttributes {
        let metrics = sectionModel.metrics
        
        var attr: SwiftyCollectionViewLayoutAttributes
        if let cachedAttr = getCachedItem(at: indexPath) {
            attr = cachedAttr
        } else {
            attr = SwiftyCollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        
        let containerWidth = collectionViewSize.width - metrics.sectionInset.left - metrics.sectionInset.right
        let containerHeight = collectionViewSize.height - metrics.sectionInset.top - metrics.sectionInset.bottom
        
        attr.sizeMode = correctSizeMode
        attr.scrollDirection = scrollDirection
        attr.maxSize = CGSize(width: containerWidth, height: containerHeight)
        attr.frame = frame
        return attr
    }
}

extension ModeState {
    private func waterFlowLayout(sectionModel: SectionModel, numberOfColumns: Int) {
        var bodyColumnLengths: [CGFloat] = []
        for _ in 0..<numberOfColumns {
            bodyColumnLengths.append(.zero)
        }
        sectionModel.waterFlowBodyColumnLengths = bodyColumnLengths
        
        for itemModel in sectionModel.itemModels {
            waterFlowLayoutForItem(sectionModel: sectionModel, itemModel: itemModel)
        }
    }
    
    private func waterFlowLayoutForItem(sectionModel: SectionModel, itemModel: ItemModel) {
        var waterFlowBodyColumnLengths = sectionModel.waterFlowBodyColumnLengths
        
        let metrics = sectionModel.metrics
        let numberOfColumns = waterFlowBodyColumnLengths.count
        
        if numberOfColumns <= 0 {
            return // ensure not empty
        }
        
        var frame = itemModel.frame
        
        // Find min
        var minGoup: (index: Int, length: CGFloat) = (0, waterFlowBodyColumnLengths[0])
        for (index, length) in waterFlowBodyColumnLengths.enumerated() {
            if length.isLess(than: minGoup.length) {
                minGoup = (index, length)
            }
        }
        switch scrollDirection {
            case .vertical:
                let allSpace = metrics.sectionInset.left + metrics.sectionInset.right + CGFloat(numberOfColumns - 1) * metrics.interitemSpacing
                let columnWidth = (collectionViewSize.width - allSpace) / CGFloat(numberOfColumns)
                
                frame.size.width = columnWidth
                
                frame.origin.x = metrics.sectionInset.left + (metrics.interitemSpacing + columnWidth) * CGFloat(minGoup.index)
                
                if !minGoup.length.isLessThanOrEqualTo(.zero) {
                    frame.origin.y = minGoup.length + metrics.lineSpacing
                    waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + metrics.lineSpacing + frame.size.height
                } else {
                    frame.origin.y = .zero
                    waterFlowBodyColumnLengths[minGoup.index] = frame.size.height
                }
                
                // reset sizeMode.width
                itemModel.correctSizeMode = InternalSizeMode(width: .absolute(length: columnWidth), height: itemModel.correctSizeMode.height)
                
            case .horizontal:
                let allSpace = metrics.sectionInset.top + metrics.sectionInset.bottom + CGFloat(numberOfColumns - 1) * metrics.interitemSpacing
                let columnHeight = (collectionViewSize.height - allSpace) / CGFloat(numberOfColumns)
                
                frame.size.height = columnHeight
                
                frame.origin.y = metrics.sectionInset.top + (metrics.interitemSpacing + columnHeight) * CGFloat(minGoup.index)
                
                if !minGoup.length.isLessThanOrEqualTo(.zero) {
                    frame.origin.x = minGoup.length + metrics.lineSpacing
                    waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + metrics.lineSpacing + frame.size.width
                } else {
                    frame.origin.x = .zero
                    waterFlowBodyColumnLengths[minGoup.index] = frame.size.width
                }
                
                // reset sizeMode.height
                itemModel.correctSizeMode = InternalSizeMode(width: itemModel.correctSizeMode.width, height: .absolute(length: columnHeight))
                
            default:
                break
        }
        sectionModel.waterFlowBodyColumnLengths = waterFlowBodyColumnLengths
        
        itemModel.frame = frame
    }
}

extension ModeState {
    private func rowLayout(sectionModel: SectionModel,
                           direction: SwiftyCollectionViewRowDirection,
                           alignment: SwiftyCollectionViewRowAlignment) {
        switch scrollDirection {
            case .vertical:
                rowVerticalLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
            case .horizontal:
                rowHorizontalLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
            default:
                break
        }
    }
    
    private func rowVerticalLayout(sectionModel: SectionModel,
                                   direction: SwiftyCollectionViewRowDirection,
                                   alignment: SwiftyCollectionViewRowAlignment) {
        let metrics = sectionModel.metrics
        
        var preItemModel: ItemModel?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subItems: [ItemModel] = []
        var groupItems: [[ItemModel]] = []
        
        let containerWidth = collectionViewSize.width - metrics.sectionInset.left - metrics.sectionInset.right
        
        switch direction {
            case .left:
                // left
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        let remain = x + metrics.interitemSpacing + itemModel.frame.width
                        
                        /// Sometimes, preferredAttributes.size is different from the actual size.
                        /// `isLessThanOrEqualTo` will return false. so, if difference between the two is less or equal to threshold,
                        /// I think it's equal
                        let isEqual = remain.isEqual(to: collectionViewSize.width - metrics.sectionInset.right, threshold: 1.0)
                        let isLessThanOrEqualTo = remain.isLessThanOrEqualTo(collectionViewSize.width - metrics.sectionInset.right)
                        
                        if isEqual || isLessThanOrEqualTo {
                            // no new line
                            itemModel.frame = CGRect(x: x + metrics.interitemSpacing,
                                                     y: preItemModel!.frame.origin.y,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            x += (metrics.interitemSpacing + itemModel.frame.width)
                            if y.isLess(than: itemModel.frame.maxY) {
                                y = itemModel.frame.maxY
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            y += metrics.lineSpacing
                            x = metrics.sectionInset.left
                            
                            if !subItems.isEmpty {
                                groupItems.append(subItems)
                            }
                            subItems.removeAll()
                            
                            let w = min(itemModel.frame.width, containerWidth)
                            itemModel.frame = CGRect(x: x,
                                                     y: y,
                                                     width: w,
                                                     height: itemModel.frame.height)
                            x += itemModel.frame.width
                            y += itemModel.frame.height
                            subItems.append(itemModel)
                        }
                    } else {
                        // first
                        x = metrics.sectionInset.left
                        y = .zero
                        
                        let w = min(itemModel.frame.width, containerWidth)
                        itemModel.frame = CGRect(x: x,
                                                 y: y,
                                                 width: w,
                                                 height: itemModel.frame.height)
                        x += itemModel.frame.width
                        y = itemModel.frame.height
                        subItems.append(itemModel)
                    }
                    preItemModel = itemModel
                }
                if !subItems.isEmpty {
                    groupItems.append(subItems)
                }
                subItems.removeAll()
            case .right:
                // right
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        let remain = x - metrics.interitemSpacing - itemModel.frame.width
                        
                        let isEqual = remain.isEqual(to: metrics.sectionInset.left, threshold: 1.0)
                        let isLess = remain.isLess(than: metrics.sectionInset.left)
                        
                        if isEqual || !isLess {
                            // no new line
                            itemModel.frame = CGRect(x: x - metrics.interitemSpacing - itemModel.frame.width,
                                                     y: preItemModel!.frame.origin.y,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            x -= (metrics.interitemSpacing + itemModel.frame.width)
                            if y.isLess(than: itemModel.frame.maxY) {
                                y = itemModel.frame.maxY
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            if !subItems.isEmpty {
                                groupItems.append(subItems)
                            }
                            subItems.removeAll()
                            
                            let w = min(itemModel.frame.width, containerWidth)
                            
                            y += metrics.lineSpacing
                            x = collectionViewSize.width - metrics.sectionInset.right - w
                            
                            itemModel.frame = CGRect(x: x,
                                                     y: y,
                                                     width: w,
                                                     height: itemModel.frame.height)
                            y += itemModel.frame.height
                            subItems.append(itemModel)
                        }
                    } else {
                        // first
                        let w = min(itemModel.frame.width, containerWidth)
                        
                        x = collectionViewSize.width - metrics.sectionInset.right - w
                        y = .zero
                        
                        itemModel.frame = CGRect(x: x,
                                                 y: y,
                                                 width: w,
                                                 height: itemModel.frame.height)
                        y = itemModel.frame.height
                        subItems.append(itemModel)
                    }
                    preItemModel = itemModel
                }
                if !subItems.isEmpty {
                    groupItems.append(subItems)
                }
                subItems.removeAll()
        }
        rowAlignment(alignment: alignment, groupItems: groupItems)
    }
    
    private func rowHorizontalLayout(sectionModel: SectionModel,
                                     direction: SwiftyCollectionViewRowDirection,
                                     alignment: SwiftyCollectionViewRowAlignment) {
        let metrics = sectionModel.metrics
        
        var preItemModel: ItemModel?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subItems: [ItemModel] = []
        var groupItems: [[ItemModel]] = []
        
        let containerHeight = collectionViewSize.height - metrics.sectionInset.top - metrics.sectionInset.bottom
        
        switch direction {
            case .left:
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        let remain = y + metrics.interitemSpacing + itemModel.frame.height
                        
                        let isEqual = remain.isEqual(to: collectionViewSize.height - metrics.sectionInset.bottom, threshold: 1.0)
                        let isLessThanOrEqualTo = remain.isLessThanOrEqualTo(collectionViewSize.height - metrics.sectionInset.bottom)
                        
                        if isEqual || isLessThanOrEqualTo {
                            // no new line
                            itemModel.frame = CGRect(x: preItemModel!.frame.origin.x,
                                                     y: y + metrics.interitemSpacing,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            y += (metrics.interitemSpacing + itemModel.frame.height)
                            if x.isLess(than: itemModel.frame.maxX) {
                                x = itemModel.frame.maxX
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            y = metrics.sectionInset.top
                            x += metrics.lineSpacing
                            
                            if !subItems.isEmpty {
                                groupItems.append(subItems)
                            }
                            subItems.removeAll()
                            
                            let h = min(itemModel.frame.height, containerHeight)
                            itemModel.frame = CGRect(x: x,
                                                     y: y,
                                                     width: itemModel.frame.width,
                                                     height: h)
                            x += itemModel.frame.width
                            y += itemModel.frame.height
                            subItems.append(itemModel)
                        }
                    } else {
                        // first
                        x = .zero
                        y = metrics.sectionInset.top
                        
                        let h = min(itemModel.frame.height, containerHeight)
                        itemModel.frame = CGRect(x: x,
                                                 y: y,
                                                 width: itemModel.frame.width,
                                                 height: h)
                        x = itemModel.frame.width
                        y += itemModel.frame.height
                        subItems.append(itemModel)
                    }
                    preItemModel = itemModel
                }
                if !subItems.isEmpty {
                    groupItems.append(subItems)
                }
                subItems.removeAll()
            case .right:
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        let remain = y - metrics.interitemSpacing - itemModel.frame.height
                        
                        let isEqual = remain.isEqual(to: metrics.sectionInset.top, threshold: 1.0)
                        let isLess = remain.isLess(than: metrics.sectionInset.top)
                        
                        if isEqual || !isLess {
                            // no new line
                            itemModel.frame = CGRect(x: preItemModel!.frame.origin.x,
                                                     y: y - metrics.interitemSpacing - itemModel.frame.height,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            y -= (metrics.interitemSpacing + itemModel.frame.height)
                            if x.isLess(than: itemModel.frame.maxX) {
                                x = itemModel.frame.maxX
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            if !subItems.isEmpty {
                                groupItems.append(subItems)
                            }
                            subItems.removeAll()
                            
                            let h = min(itemModel.frame.height, containerHeight)
                            
                            y = collectionViewSize.height - metrics.sectionInset.bottom - h
                            x += metrics.lineSpacing
                            
                            itemModel.frame = CGRect(x: x,
                                                     y: y,
                                                     width: itemModel.frame.width,
                                                     height: h)
                            x += itemModel.frame.width
                            subItems.append(itemModel)
                        }
                    } else {
                        // first
                        let h = min(itemModel.frame.height, containerHeight)
                        
                        x = .zero
                        y = collectionViewSize.height - metrics.sectionInset.bottom - h
                        
                        itemModel.frame = CGRect(x: x,
                                                 y: y,
                                                 width: itemModel.frame.width,
                                                 height: h)
                        x = itemModel.frame.width
                        subItems.append(itemModel)
                    }
                    preItemModel = itemModel
                }
                if !subItems.isEmpty {
                    groupItems.append(subItems)
                }
                subItems.removeAll()
        }
        rowAlignment(alignment: alignment, groupItems: groupItems)
    }
    
    private func rowAlignment(alignment: SwiftyCollectionViewRowAlignment, groupItems: [[ItemModel]]) {
        //
        if groupItems.isEmpty { return }
        //
        for items in groupItems {
            if items.isEmpty { continue }
            var maxHeightItem = items.first!
            var maxWidthItem = items.first!
            for item in items {
                if maxHeightItem.frame.height.isLess(than: item.frame.height) {
                    maxHeightItem = item
                }
                if maxWidthItem.frame.width.isLess(than: item.frame.width) {
                    maxWidthItem = item
                }
            }
            //
            switch alignment {
                case .top:
                    switch scrollDirection {
                        case .vertical:
                            for item in items {
                                var frame = item.frame
                                frame.origin.y = maxHeightItem.frame.minY
                                item.frame = frame
                            }
                        case .horizontal:
                            for item in items {
                                var frame = item.frame
                                frame.origin.x = maxWidthItem.frame.minX
                                item.frame = frame
                            }
                        default:
                            break
                    }
                case .center:
                    switch scrollDirection {
                        case .vertical:
                            for item in items {
                                var frame = item.frame
                                frame.origin.y = maxHeightItem.frame.minY + (maxHeightItem.frame.height - item.frame.height) / 2.0
                                item.frame = frame
                            }
                        case .horizontal:
                            for item in items {
                                var frame = item.frame
                                frame.origin.x = maxWidthItem.frame.minX + (maxWidthItem.frame.width - item.frame.width) / 2.0
                                item.frame = frame
                            }
                        default:
                            break
                    }
                case .bottom:
                    switch scrollDirection {
                        case .vertical:
                            for item in items {
                                var frame = item.frame
                                frame.origin.y = maxHeightItem.frame.maxY - item.frame.height
                                item.frame = frame
                            }
                        case .horizontal:
                            for item in items {
                                var frame = item.frame
                                frame.origin.x = maxWidthItem.frame.maxX - item.frame.width
                                item.frame = frame
                            }
                        default:
                            break
                    }
            }
        }
    }
}
