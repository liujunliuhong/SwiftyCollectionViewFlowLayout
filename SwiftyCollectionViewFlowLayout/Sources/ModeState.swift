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
    deinit {
#if DEBUG
        print("\(self) deinit")
#endif
    }
    private var cachedHeaderLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    private var cachedFooterLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    private var cachedBackgroundLayoutAttributes: [Int: SwiftyCollectionViewLayoutAttributes] = [:]
    private var cachedItemLayoutAttributes: [Int: [Int: SwiftyCollectionViewLayoutAttributes]] = [:]
    
    private var currentSectionModels: [SectionModel] = []
    private var sectionModelsBeforeBatchUpdates = [SectionModel]()
    
    internal weak var layout: SwiftyCollectionViewFlowLayout?
    
    internal var scrollDirection: UICollectionView.ScrollDirection {
        return layout?.scrollDirection ?? Default.scrollDirection
    }
    
    internal var collectionViewSize: CGSize {
        return layout?.mCollectionView.bounds.size ?? Default.size
    }
    
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
    
    internal func updateItemSizeMode(correctSizeMode: InternalSizeMode, at indexPath: IndexPath) {
        let sectionModel = sectionModel(at: indexPath.section)
        guard let itemModel = itemModel(sectionModel?.itemModels, index: indexPath.item) else { return }
        itemModel.correctSizeMode = correctSizeMode
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
    
    internal func cacheItem(_ attr: SwiftyCollectionViewLayoutAttributes, at indexPath: IndexPath) {
        if var dic = cachedItemLayoutAttributes[indexPath.section] {
            dic[indexPath.item] = attr
            cachedItemLayoutAttributes[indexPath.section] = dic
        } else {
            cachedItemLayoutAttributes[indexPath.section] = [indexPath.item: attr]
        }
    }
    
    internal func getCachedItem(at indexPath: IndexPath) -> SwiftyCollectionViewLayoutAttributes? {
        return cachedItemLayoutAttributes[indexPath.section]?[indexPath.item]
    }
    
    internal func cacheHeader(_ attr: SwiftyCollectionViewLayoutAttributes, at section: Int) {
        cachedHeaderLayoutAttributes[section] = attr
    }
    
    internal func getCachedHeader(at section: Int) -> SwiftyCollectionViewLayoutAttributes? {
        return cachedHeaderLayoutAttributes[section]
    }
    
    internal func cacheFooter(_ attr: SwiftyCollectionViewLayoutAttributes, at section: Int) {
        cachedFooterLayoutAttributes[section] = attr
    }
    
    internal func getCachedFooter(at section: Int) -> SwiftyCollectionViewLayoutAttributes? {
        return cachedFooterLayoutAttributes[section]
    }
    
    internal func cacheBackground(_ attr: SwiftyCollectionViewLayoutAttributes, at section: Int) {
        cachedBackgroundLayoutAttributes[section] = attr
    }
    
    internal func getCachedBackground(at section: Int) -> SwiftyCollectionViewLayoutAttributes? {
        return cachedBackgroundLayoutAttributes[section]
    }
}

extension ModeState {
    private func updateItemSize(preferredSize: CGSize, indexPath: IndexPath) {
        guard let sectionModel = sectionModel(at: indexPath.section) else { return }
        guard let itemModel = itemModel(sectionModel.itemModels, index: indexPath.item) else { return }
        
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
        let isSameWidth = preferredAttributes.size.width.isEqual(to: originalAttributes.size.width, threshold: 1.0)
        let isSameHeight = preferredAttributes.size.height.isEqual(to: originalAttributes.size.height, threshold: 1.0)
        
        switch preferredAttributes.representedElementCategory {
            case .cell:
                let sectionModel = sectionModel(at: preferredAttributes.indexPath.section)
                guard let itemModel = itemModel(sectionModel?.itemModels, index: preferredAttributes.indexPath.item) else { return false }
                switch itemModel.correctSizeMode.width {
                    case .dynamic, .ratio:
                        switch itemModel.correctSizeMode.height {
                            case .dynamic, .ratio:
                                return !isSameWidth || !isSameHeight
                            case .absolute:
                                return !isSameWidth
                        }
                    case .absolute:
                        switch itemModel.correctSizeMode.height {
                            case .dynamic, .ratio:
                                return !isSameHeight
                            case .absolute:
                                return false
                        }
                }
            case .supplementaryView:
                switch preferredAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerModel = sectionModel(at: preferredAttributes.indexPath.section)?.headerModel else {
                            return false
                        }
                        switch headerModel.correctSizeMode.width {
                            case .dynamic,.ratio:
                                switch headerModel.correctSizeMode.height {
                                    case .dynamic, .ratio:
                                        return !isSameWidth || !isSameHeight
                                    case .absolute:
                                        return !isSameWidth
                                }
                            case .absolute:
                                switch headerModel.correctSizeMode.height {
                                    case .dynamic, .ratio:
                                        return !isSameHeight
                                    case .absolute:
                                        return false
                                }
                                
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerModel = sectionModel(at: preferredAttributes.indexPath.section)?.footerModel else {
                            return false
                        }
                        switch footerModel.correctSizeMode.width {
                            case .dynamic, .ratio:
                                switch footerModel.correctSizeMode.height {
                                    case .dynamic, .ratio:
                                        return !isSameWidth || !isSameHeight
                                    case .absolute:
                                        return !isSameWidth
                                }
                            case .absolute:
                                switch footerModel.correctSizeMode.height {
                                    case .dynamic, .ratio:
                                        return !isSameHeight
                                    case .absolute:
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
                updateItemSize(preferredSize: preferredAttributes.size,
                               indexPath: preferredAttributes.indexPath)
            case .supplementaryView:
                switch preferredAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        updateHeaderSize(preferredSize: preferredAttributes.size,
                                         section: preferredAttributes.indexPath.section)
                    case UICollectionView.elementKindSectionFooter:
                        updateFooterSize(preferredSize: preferredAttributes.size,
                                         section: preferredAttributes.indexPath.section)
                    default:
                        break
                }
            default:
                break
        }
    }
    
    internal func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        var shouldInvalidateLayout: Bool = false
        
        let isSameWidth = collectionViewSize.width.isEqual(to: newBounds.size.width, threshold: 1)
        let isSameHeight = collectionViewSize.height.isEqual(to: newBounds.size.height, threshold: 1)
        
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
                                                      correctSizeMode: headerModel.correctSizeMode)
                    cacheHeader(attr, at: section)
                    attrs.append(attr)
                }
            }
            for (index, itemModel) in sectionModel.itemModels.enumerated() {
                if rect.contains(itemModel.frame) || rect.intersects(itemModel.frame) {
                    let indexPath = IndexPath(item: index, section: section)
                    let attr = itemLayoutAttributes(at: indexPath,
                                                    frame: itemModel.frame,
                                                    sectionModel: sectionModel,
                                                    correctSizeMode: itemModel.correctSizeMode)
                    cacheItem(attr, at: indexPath)
                    attrs.append(attr)
                }
            }
            if let footerModel = sectionModel.footerModel {
                if rect.contains(footerModel.pinnedFrame) || rect.intersects(footerModel.pinnedFrame) {
                    let attr = footerLayoutAttributes(at: section,
                                                      frame: footerModel.pinnedFrame,
                                                      sectionModel: sectionModel,
                                                      correctSizeMode: footerModel.correctSizeMode)
                    cacheFooter(attr, at: section)
                    attrs.append(attr)
                }
            }
            if let backgroundModel = sectionModel.backgroundModel {
                if rect.contains(backgroundModel.frame) || rect.intersects(backgroundModel.frame) {
                    let attr = backgroundLayoutAttributes(at: section, frame: backgroundModel.frame)
                    cacheBackground(attr, at: section)
                    attrs.append(attr)
                }
            }
        }
        return attrs
    }
    
    internal func collectionViewContentSize() -> CGSize {
        var totalLength: CGFloat = .zero
        for sectionModel in currentSectionModels {
            totalLength += sectionModel.totalLength(scrollDirection: scrollDirection)
        }
        //
        var size: CGSize = .zero
        switch scrollDirection {
            case .vertical:
                size = CGSize(width: collectionViewSize.width, height: totalLength)
            case .horizontal:
                size = CGSize(width: totalLength, height: collectionViewSize.height)
            @unknown default:
                break
        }
        return size
    }
}
