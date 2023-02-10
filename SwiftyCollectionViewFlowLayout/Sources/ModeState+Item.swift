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
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: section) else { return }
        
        let scrollDirection = layout.scrollDirection
        
        switch sectionModel.sectionType {
            case .waterFlow(let numberOfColumns):
                waterFlowLayout(sectionModel: sectionModel, numberOfColumns: numberOfColumns)
            case .tagList(let direction, let alignment):
                tagListLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
        }
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        // update all items frame.origin.y or frame.origin.x
        for itemModel in sectionModel.itemModels {
            var frame = itemModel.frame
            if scrollDirection == .vertical {
                frame.origin.y += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)) // update frame.origin.y
            } else if scrollDirection == .horizontal {
                frame.origin.x += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection)) // update frame.origin.x
            }
            itemModel.frame = frame
        }
    }
    
    internal func itemLayoutAttributes(at indexPath: IndexPath, frame: CGRect, sectionModel: SectionModel, sizeMode: SwiftyCollectionViewFlowLayoutSizeMode) -> UICollectionViewLayoutAttributes {
        let attr = SwiftyCollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.sizeMode = sizeMode
        attr.sectionModel = sectionModel
        attr.layout = layout
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
        guard let layout = layout else { return }
        
        let collectionView = layout.mCollectionView
        
        let numberOfColumns = sectionModel.waterFlowBodyColumnLengths.count
        
        if sectionModel.waterFlowBodyColumnLengths.isEmpty {
            return // ensure not empty
        }
        
        let scrollDirection = layout.scrollDirection
        
        let sectionInset = sectionModel.sectionInset
        
        var frame = itemModel.frame
        
        // Find min
        var minGoup: (index: Int, length: CGFloat) = (0, sectionModel.waterFlowBodyColumnLengths[0])
        for (index, length) in sectionModel.waterFlowBodyColumnLengths.enumerated() {
            if length.isLess(than: minGoup.length) {
                minGoup = (index, length)
            }
        }
        switch scrollDirection {
            case .vertical:
                let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
                
                frame.size.width = columnWidth
                
                frame.origin.x = sectionInset.left + (sectionModel.interitemSpacing + columnWidth) * CGFloat(minGoup.index)
                
                if !minGoup.length.isLessThanOrEqualTo(.zero) {
                    frame.origin.y = minGoup.length + sectionModel.lineSpacing
                    sectionModel.waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + frame.size.height
                } else {
                    frame.origin.y = .zero
                    sectionModel.waterFlowBodyColumnLengths[minGoup.index] = frame.size.height
                }
                
                // reset sizeMode.width
                itemModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: columnWidth), height: itemModel.sizeMode.height)
                
            case .horizontal:
                let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
                
                frame.size.height = columnHeight
                
                frame.origin.y = sectionInset.top + (sectionModel.interitemSpacing + columnHeight) * CGFloat(minGoup.index)
                
                if !minGoup.length.isLessThanOrEqualTo(.zero) {
                    frame.origin.x = minGoup.length + sectionModel.lineSpacing
                    sectionModel.waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + frame.size.width
                } else {
                    frame.origin.x = .zero
                    sectionModel.waterFlowBodyColumnLengths[minGoup.index] = frame.size.width
                }
                
                // reset sizeMode.height
                itemModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: itemModel.sizeMode.width, height: .static(length: columnHeight))
                
            default:
                break
        }
        itemModel.frame = frame
    }
}

extension ModeState {
    private func tagListLayout(sectionModel: SectionModel,
                               direction: SwiftyCollectionViewTagDirection,
                               alignment: SwiftyCollectionViewTagAlignment) {
        guard let layout = layout else { return }
        let scrollDirection = layout.scrollDirection
        switch scrollDirection {
            case .vertical:
                tagListVerticalLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
            case .horizontal:
                tagListHorizontalLayout(sectionModel: sectionModel, direction: direction, alignment: alignment)
            default:
                break
        }
    }
    
    private func tagListVerticalLayout(sectionModel: SectionModel,
                                       direction: SwiftyCollectionViewTagDirection,
                                       alignment: SwiftyCollectionViewTagAlignment) {
        guard let layout = layout else { return }
        let collectionView = layout.mCollectionView
        
        var preItemModel: ItemModel?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subItems: [ItemModel] = []
        var groupItems: [[ItemModel]] = []
        
        let containerWidth = collectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
        
        switch direction {
            case .left:
                // left
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        if (x + sectionModel.interitemSpacing + itemModel.frame.width).isLessThanOrEqualTo(collectionView.bounds.width - sectionModel.sectionInset.right) {
                            // no new line
                            itemModel.frame = CGRect(x: x + sectionModel.interitemSpacing,
                                                     y: preItemModel!.frame.origin.y,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            x += (sectionModel.interitemSpacing + itemModel.frame.width)
                            if y.isLess(than: itemModel.frame.maxY) {
                                y = itemModel.frame.maxY
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            y += sectionModel.lineSpacing
                            x = sectionModel.sectionInset.left
                            
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
                        x = sectionModel.sectionInset.left
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
                        if !(x - sectionModel.interitemSpacing - itemModel.frame.width).isLess(than: sectionModel.sectionInset.left) {
                            // no new line
                            itemModel.frame = CGRect(x: x - sectionModel.interitemSpacing - itemModel.frame.width,
                                                     y: preItemModel!.frame.origin.y,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            x -= (sectionModel.interitemSpacing + itemModel.frame.width)
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
                            
                            y += sectionModel.lineSpacing
                            x = collectionView.bounds.width - sectionModel.sectionInset.right - w
                            
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
                        
                        x = collectionView.bounds.width - sectionModel.sectionInset.right - w
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
        tagListAlignment(alignment: alignment, groupItems: groupItems, scrollDirection: layout.scrollDirection)
    }
    
    private func tagListHorizontalLayout(sectionModel: SectionModel,
                                         direction: SwiftyCollectionViewTagDirection,
                                         alignment: SwiftyCollectionViewTagAlignment) {
        guard let layout = layout else { return }
        let collectionView = layout.mCollectionView
        
        var preItemModel: ItemModel?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subItems: [ItemModel] = []
        var groupItems: [[ItemModel]] = []
        
        let containerHeight: CGFloat = collectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
        
        switch direction {
            case .left:
                for itemModel in sectionModel.itemModels {
                    if preItemModel != nil {
                        if (y + sectionModel.interitemSpacing + itemModel.frame.height).isLessThanOrEqualTo(collectionView.bounds.height - sectionModel.sectionInset.bottom) {
                            // no new line
                            itemModel.frame = CGRect(x: preItemModel!.frame.origin.x,
                                                     y: y + sectionModel.interitemSpacing,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            y += (sectionModel.interitemSpacing + itemModel.frame.height)
                            if x.isLess(than: itemModel.frame.maxX) {
                                x = itemModel.frame.maxX
                            }
                            subItems.append(itemModel)
                        } else {
                            // new line
                            y = sectionModel.sectionInset.top
                            x += sectionModel.lineSpacing
                            
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
                        y = sectionModel.sectionInset.top
                        
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
                        if !(y - sectionModel.interitemSpacing - itemModel.frame.height).isLess(than: sectionModel.sectionInset.top) {
                            // no new line
                            itemModel.frame = CGRect(x: preItemModel!.frame.origin.x,
                                                     y: y - sectionModel.interitemSpacing - itemModel.frame.height,
                                                     width: itemModel.frame.width,
                                                     height: itemModel.frame.height)
                            y -= (sectionModel.interitemSpacing + itemModel.frame.height)
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
                            
                            y = collectionView.bounds.height - sectionModel.sectionInset.bottom - h
                            x += sectionModel.lineSpacing
                            
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
                        y = collectionView.bounds.height - sectionModel.sectionInset.bottom - h
                        
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
        tagListAlignment(alignment: alignment, groupItems: groupItems, scrollDirection: layout.scrollDirection)
    }
    
    private func tagListAlignment(alignment: SwiftyCollectionViewTagAlignment, groupItems: [[ItemModel]], scrollDirection: UICollectionView.ScrollDirection) {
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
