//
//  ModeState.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

/// Manages the state of section and element models.
internal final class ModeState {
    
    internal var cachedHeaderLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    internal var cachedFooterLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    internal var cachedBackgroundLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    internal var cachedItemLayoutAttributes: [Int: [Int: SwiftyCollectionViewLayoutAttributes]] = [:]
    
    private var currentSectionModels: [SectionModel] = []
    private var sectionModelsBeforeBatchUpdates = [SectionModel]()
    
    internal weak var layout: SwiftyCollectionViewFlowLayout?
    
    internal init(layout: SwiftyCollectionViewFlowLayout) {
        self.layout = layout
    }
}

extension ModeState {
    internal func clear() {
        currentSectionModels.removeAll()
        cachedItemLayoutAttributes.removeAll()
        cachedHeaderLayoutAttributes.removeAll()
        cachedFooterLayoutAttributes.removeAll()
        cachedBackgroundLayoutAttributes.removeAll()
    }
    
    internal func setSections(_ sectionModels: [SectionModel]) {
        currentSectionModels = sectionModels
    }
}

extension ModeState {
    internal func numberOfSections() -> Int {
        return currentSectionModels.count
    }
    
    internal func numberOfItems(at section: Int) -> Int {
        return sectionModel(at: section)?.itemModels.count ?? .zero
    }
    
    internal func itemModel(_ itemModels: [ItemModel]?, index: Int) -> ItemModel? {
        guard let itemModels = itemModels else { return nil }
        if index < 0 || index > itemModels.count - 1 { return nil }
        let itemModel = itemModels[index]
        return itemModel
    }
    
    internal func sectionModel(at section: Int) -> SectionModel? {
        if section < 0 || section > currentSectionModels.count - 1 { return nil }
        let sectionModel = currentSectionModels[section]
        return sectionModel
    }
    
    internal func previousSectionTotalLength(currentSection: Int) -> CGFloat {
        guard let layout = layout else { return .zero }
        let scrollDirection = layout.scrollDirection
        var totalLength: CGFloat = .zero
        for (i, sectionModel) in currentSectionModels.enumerated() {
            if i < currentSection {
                totalLength += sectionModel.totalLength(scrollDirection: scrollDirection)
            }
        }
        return totalLength
    }
    
    internal func applyUpdates(_ updates: [CollectionViewUpdate<SectionModel, ItemModel>]) {
        
        sectionModelsBeforeBatchUpdates = currentSectionModels
        
        var sectionModelReloadIndexPairs = [(sectionModel: SectionModel, reloadIndex: Int)]()
        var itemModelReloadIndexPathPairs = [(itemModel: ItemModel, reloadIndexPath: IndexPath)]()
        
        var sectionIndicesToDelete = [Int]()
        var itemIndexPathsToDelete = [IndexPath]()
        
        var sectionModelInsertIndexPairs = [(sectionModel: SectionModel, insertIndex: Int)]()
        var itemModelInsertIndexPathPairs = [(itemModel: ItemModel, insertIndexPath: IndexPath)]()
        
        for update in updates {
            switch update {
                case let .sectionReload(sectionIndex, newSection):
                    sectionModelReloadIndexPairs.append((newSection, sectionIndex))
                case let .itemReload(itemIndexPath, newItem):
                    itemModelReloadIndexPathPairs.append((newItem, itemIndexPath))
                case let .sectionDelete(sectionIndex):
                    sectionIndicesToDelete.append(sectionIndex)
                case let .itemDelete(itemIndexPath):
                    itemIndexPathsToDelete.append(itemIndexPath)
                case let .sectionMove(initialSectionIndex, finalSectionIndex):
                    sectionIndicesToDelete.append(initialSectionIndex)
                    let sectionModelToMove = sectionModelsBeforeBatchUpdates[initialSectionIndex]
                    sectionModelInsertIndexPairs.append((sectionModelToMove, finalSectionIndex))
                case let .itemMove(initialItemIndexPath, finalItemIndexPath):
                    itemIndexPathsToDelete.append(initialItemIndexPath)
                    let sectionContainingItemModelToMove = sectionModelsBeforeBatchUpdates[initialItemIndexPath.section]
                    let itemModelToMove = sectionContainingItemModelToMove.itemModels[initialItemIndexPath.item]
                    itemModelInsertIndexPathPairs.append((itemModelToMove, finalItemIndexPath))
                case let .sectionInsert(sectionIndex, newSection):
                    sectionModelInsertIndexPairs.append((newSection, sectionIndex))
                case let .itemInsert(itemIndexPath, newItem):
                    itemModelInsertIndexPathPairs.append((newItem, itemIndexPath))
            }
        }
        
        reloadItemModels(itemModelReloadIndexPathPairs: itemModelReloadIndexPathPairs)
        reloadSectionModels(sectionModelReloadIndexPairs: sectionModelReloadIndexPairs)
        
        deleteItemModels(atIndexPaths: itemIndexPathsToDelete)
        deleteSectionModels(atIndices: sectionIndicesToDelete)
        
        insertSectionModels(sectionModelInsertIndexPairs: sectionModelInsertIndexPairs)
        insertItemModels(itemModelInsertIndexPathPairs: itemModelInsertIndexPathPairs)
    }
    
    internal func clearInProgressBatchUpdateState() {
        sectionModelsBeforeBatchUpdates.removeAll()
    }
    
    internal func setHeader(headerModel: HeaderModel, at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        if let oldHeaderModel = sectionModel.headerModel {
            headerModel.frame = oldHeaderModel.frame
        }
        sectionModel.headerModel = headerModel
    }
    
    internal func removeHeader(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        sectionModel.headerModel = nil
    }
    
    internal func setFooter(footerModel: FooterModel, at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        if let oldFooterModel = sectionModel.footerModel {
            footerModel.frame = oldFooterModel.frame
        }
        sectionModel.footerModel = footerModel
    }
    
    internal func removeFooter(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        sectionModel.footerModel = nil
    }
    
    internal func setBackground(backgroundModel: BackgroundModel, at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        sectionModel.backgroundModel = backgroundModel
    }
    
    internal func removeBackground(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        sectionModel.backgroundModel = nil
    }
    
    internal func updateItemSizeMode(sizeMode: SwiftyCollectionViewLayoutSizeMode, at indexPath: IndexPath) {
        let sectionModel = sectionModel(at: indexPath.section)
        guard let itemModel = itemModel(sectionModel?.itemModels, index: indexPath.item) else { return }
        itemModel.sizeMode = sizeMode
    }
    
    internal func updateMetrics(_ metrics: SectionMetrics, at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        sectionModel.metrics = metrics
    }
    
    internal func hasPinnedHeaderOrFooter() -> Bool {
        var hasPinnedHeaderOrFooter: Bool = false
        for sectionModel in currentSectionModels {
            hasPinnedHeaderOrFooter = hasPinnedHeaderOrFooter || sectionModel.metrics.headerPinToVisibleBounds
            hasPinnedHeaderOrFooter = hasPinnedHeaderOrFooter || sectionModel.metrics.footerPinToVisibleBounds
        }
        return hasPinnedHeaderOrFooter
    }
}

extension ModeState {
    private func updateItemSize(preferredSize: CGSize, indexPath: IndexPath) {
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: indexPath.section) else { return }
        guard let itemModel = itemModel(sectionModel.itemModels, index: indexPath.item) else { return }
        
        let scrollDirection = layout.scrollDirection
        
        switch sectionModel.metrics.sectionType {
            case .waterFlow:
                switch scrollDirection {
                    case .vertical:
                        var frame = itemModel.frame
                        frame.size.height = preferredSize.height // update height
                        itemModel.frame = frame
                    case .horizontal:
                        var frame = itemModel.frame
                        frame.size.width = preferredSize.width // update width
                        itemModel.frame = frame
                    default:
                        break
                }
            case .row:
                var frame = itemModel.frame
                frame.size.width = preferredSize.width // update width
                frame.size.height = preferredSize.height // update height
                itemModel.frame = frame
        }
    }
    
    private func updateHeaderSize(preferredSize: CGSize, section: Int) {
        guard let headerModel = sectionModel(at: section)?.headerModel else {
            return
        }
        var frame = headerModel.frame
        frame.size.width = preferredSize.width // update width
        frame.size.height = preferredSize.height // update height
        headerModel.frame = frame
    }
    
    private func updateFooterSize(preferredSize: CGSize, section: Int) {
        guard let footerModel = sectionModel(at: section)?.footerModel else {
            return
        }
        var frame = footerModel.frame
        frame.size.width = preferredSize.width // update width
        frame.size.height = preferredSize.height // update height
        footerModel.frame = frame
    }
    
    private func reloadSectionModels(sectionModelReloadIndexPairs: [(sectionModel: SectionModel, reloadIndex: Int)]) {
        for (sectionModel, reloadIndex) in sectionModelReloadIndexPairs {
            currentSectionModels.remove(at: reloadIndex)
            currentSectionModels.insert(sectionModel, at: reloadIndex)
        }
    }
    
    private func reloadItemModels(itemModelReloadIndexPathPairs: [(itemModel: ItemModel, reloadIndexPath: IndexPath)]) {
        for (itemModel, reloadIndexPath) in itemModelReloadIndexPathPairs {
            currentSectionModels[reloadIndexPath.section].itemModels.remove(at: reloadIndexPath.item)
            currentSectionModels[reloadIndexPath.section].itemModels.insert(itemModel, at: reloadIndexPath.count)
        }
    }
    
    private func deleteSectionModels(atIndices indicesOfSectionModelsToDelete: [Int]) {
        // Always delete in descending order
        for indexOfSectionModelToDelete in (indicesOfSectionModelsToDelete.sorted { $0 > $1 }) {
            currentSectionModels.remove(at: indexOfSectionModelToDelete)
        }
    }
    
    private func deleteItemModels(atIndexPaths indexPathsOfItemModelsToDelete: [IndexPath]) {
        // Always delete in descending order
        for indexPathOfItemModelToDelete in (indexPathsOfItemModelsToDelete.sorted { $0 > $1 }) {
            currentSectionModels[indexPathOfItemModelToDelete.section].itemModels.remove(at: indexPathOfItemModelToDelete.item)
        }
    }
    
    private func insertSectionModels(sectionModelInsertIndexPairs: [(sectionModel: SectionModel, insertIndex: Int)]) {
        // Always insert in ascending order
        for (sectionModel, insertIndex) in (sectionModelInsertIndexPairs.sorted { $0.insertIndex < $1.insertIndex }) {
            currentSectionModels.insert(sectionModel, at: insertIndex)
        }
    }
    
    private func insertItemModels(itemModelInsertIndexPathPairs: [(itemModel: ItemModel, insertIndexPath: IndexPath)]) {
        // Always insert in ascending order
        for (itemModel, insertIndexPath) in (itemModelInsertIndexPathPairs.sorted { $0.insertIndexPath < $1.insertIndexPath }) {
            currentSectionModels[insertIndexPath.section].itemModels.insert(itemModel, at: insertIndexPath.item)
        }
    }
}

extension ModeState {
    internal func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        let isSameWidth = preferredAttributes.size.width.isEqual(to: originalAttributes.size.width)
        let isSameHeight = preferredAttributes.size.height.isEqual(to: originalAttributes.size.height)
        
        switch preferredAttributes.representedElementCategory {
            case .cell:
                let sectionModel = sectionModel(at: preferredAttributes.indexPath.section)
                guard let itemModel = itemModel(sectionModel?.itemModels, index: preferredAttributes.indexPath.item) else { return false }
                switch itemModel.sizeMode.width {
                    case .dynamic, .full, .fractionalFull:
                        switch itemModel.sizeMode.height {
                            case .dynamic, .full, .fractionalFull:
                                return !isSameWidth || !isSameHeight
                            case .static:
                                return !isSameWidth
                        }
                    case .static:
                        switch itemModel.sizeMode.height {
                            case .dynamic, .full, .fractionalFull:
                                return !isSameHeight
                            case .static:
                                return false
                        }
                }
            case .supplementaryView:
                switch preferredAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerModel = sectionModel(at: preferredAttributes.indexPath.section)?.headerModel else {
                            return false
                        }
                        switch headerModel.sizeMode.width {
                            case .dynamic, .full, .fractionalFull:
                                switch headerModel.sizeMode.height {
                                    case .dynamic, .full, .fractionalFull:
                                        return !isSameWidth || !isSameHeight
                                    case .static:
                                        return !isSameWidth
                                }
                            case .static:
                                switch headerModel.sizeMode.height {
                                    case .dynamic, .full, .fractionalFull:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                                
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerModel = sectionModel(at: preferredAttributes.indexPath.section)?.footerModel else {
                            return false
                        }
                        switch footerModel.sizeMode.width {
                            case .dynamic, .full, .fractionalFull:
                                switch footerModel.sizeMode.height {
                                    case .dynamic, .full, .fractionalFull:
                                        return !isSameWidth || !isSameHeight
                                    case .static:
                                        return !isSameWidth
                                }
                            case .static:
                                switch footerModel.sizeMode.height {
                                    case .dynamic, .full, .fractionalFull:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                        }
                    default:
                        break
                }
            default:
                break
        }
        return false
    }
    
    internal func updatePreferredLayoutAttributesSize(preferredAttributes: UICollectionViewLayoutAttributes) {
        // Sometimes, preferredAttributes.size is different from the actual size.
        switch preferredAttributes.representedElementCategory {
            case .cell:
                updateItemSize(preferredSize: preferredAttributes.size, indexPath: preferredAttributes.indexPath)
            case .supplementaryView:
                switch preferredAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        updateHeaderSize(preferredSize: preferredAttributes.size, section: preferredAttributes.indexPath.section)
                    case UICollectionView.elementKindSectionFooter:
                        updateFooterSize(preferredSize: preferredAttributes.size, section: preferredAttributes.indexPath.section)
                    default:
                        break
                }
            default:
                break
        }
    }
    
    internal func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let layout = layout else { return false }
        var shouldInvalidateLayout: Bool = false
        
        let scrollDirection = layout.scrollDirection
        
        let isSameWidth = layout.mCollectionView.bounds.width.isEqual(to: newBounds.size.width)
        let isSameHeight = layout.mCollectionView.bounds.height.isEqual(to: newBounds.size.height)
        
        switch scrollDirection {
            case .vertical:
                shouldInvalidateLayout = !isSameHeight
            case .horizontal:
                shouldInvalidateLayout = !isSameWidth
            default:
                break
        }
        return shouldInvalidateLayout
    }
    
    internal func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        for section in 0..<currentSectionModels.count {
            layoutHeaderModel(at: section)
            layoutItemModels(at: section)
            layoutFooterModel(at: section)
            layoutBackgroundModel(at: section)
            pinned(at: section)
        }
        
        var attrs: [UICollectionViewLayoutAttributes] = []
        for (section, sectionModel) in currentSectionModels.enumerated() {
            if let headerModel = sectionModel.headerModel {
                if rect.contains(headerModel.pinnedFrame) || rect.intersects(headerModel.pinnedFrame) {
                    let attr = headerLayoutAttributes(at: section,
                                                      frame: headerModel.pinnedFrame,
                                                      sectionModel: sectionModel,
                                                      sizeMode: headerModel.sizeMode)
                    cachedHeaderLayoutAttributes[section] = attr
                    attrs.append(attr)
                }
            }
            for (index, itemModel) in sectionModel.itemModels.enumerated() {
                if rect.contains(itemModel.frame) || rect.intersects(itemModel.frame) {
                    let indexPath = IndexPath(item: index, section: section)
                    let attr = itemLayoutAttributes(at: indexPath,
                                                    frame: itemModel.frame,
                                                    sectionModel: sectionModel,
                                                    sizeMode: itemModel.sizeMode)
                    
                    if var dic = cachedItemLayoutAttributes[indexPath.section] {
                        dic[indexPath.item] = attr
                        cachedItemLayoutAttributes[indexPath.section] = dic
                    } else {
                        cachedItemLayoutAttributes[indexPath.section] = [indexPath.section: attr]
                    }
                    attrs.append(attr)
                }
            }
            if let footerModel = sectionModel.footerModel {
                if rect.contains(footerModel.pinnedFrame) || rect.intersects(footerModel.pinnedFrame) {
                    let attr = footerLayoutAttributes(at: section,
                                                      frame: footerModel.pinnedFrame,
                                                      sectionModel: sectionModel,
                                                      sizeMode: footerModel.sizeMode)
                    cachedFooterLayoutAttributes[section] = attr
                    attrs.append(attr)
                }
            }
            if let backgroundModel = sectionModel.backgroundModel {
                if rect.contains(backgroundModel.frame) || rect.intersects(backgroundModel.frame) {
                    let attr = backgroundLayoutAttributes(at: section, frame: backgroundModel.frame, sectionModel: sectionModel)
                    cachedBackgroundLayoutAttributes[section] = attr
                    attrs.append(attr)
                }
            }
        }
        return attrs
    }
    
    internal func collectionViewContentSize() -> CGSize {
        guard let layout = layout else { return .zero }
        let scrollDirection = layout.scrollDirection
        //
        var totalLength: CGFloat = .zero
        for sectionModel in currentSectionModels {
            totalLength += sectionModel.totalLength(scrollDirection: scrollDirection)
        }
        //
        var size: CGSize = .zero
        switch scrollDirection {
            case .vertical:
                size = CGSize(width: layout.mCollectionView.bounds.width, height: totalLength)
            case .horizontal:
                size = CGSize(width: totalLength, height: layout.mCollectionView.bounds.height)
            @unknown default:
                break
        }
        return size
    }
}
