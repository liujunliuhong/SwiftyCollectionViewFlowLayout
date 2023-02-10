//
//  ModeState.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

internal final class ModeState {
    
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
    }
    
    internal func setSections(_ sectionModels: [SectionModel]) {
        currentSectionModels = sectionModels
    }
}

extension ModeState {
    internal func numberOfSections() -> Int {
        return currentSectionModels.count
    }
    
    internal func itemModel(at indexPath: IndexPath) -> ItemModel? {
        guard let sectionModel = sectionModel(at: indexPath.section) else {
            return nil
        }
        let itemModels = sectionModel.itemModels
        if indexPath.item < 0 || indexPath.item > itemModels.count - 1 {
            return nil
        }
        let itemModel = itemModels[indexPath.item]
        return itemModel
    }
    
    internal func sectionModel(at section: Int) -> SectionModel? {
        if section < 0 || section > currentSectionModels.count - 1 {
            return nil
        }
        let sectionModel = currentSectionModels[section]
        return sectionModel
    }
    
    internal func headerModel(at section: Int) -> HeaderModel? {
        return sectionModel(at: section)?.headerModel
    }
    
    internal func footerModel(at section: Int) -> FooterModel? {
        return sectionModel(at: section)?.footerModel
    }
    
    internal func decorationModel(at section: Int) -> DecorationModel? {
        return sectionModel(at: section)?.decorationModel
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
                    if let itemModelToMove = itemModel(at: initialItemIndexPath) {
                        itemModelInsertIndexPathPairs.append((itemModelToMove, finalItemIndexPath))
                    }
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
        sectionModel(at: section)?.headerModel = headerModel
    }
    
    internal func removeHeader(at section: Int) {
        sectionModel(at: section)?.headerModel = nil
    }
    
    internal func setFooter(footerModel: FooterModel, at section: Int) {
        sectionModel(at: section)?.footerModel = footerModel
    }
    
    internal func removeFooter(at section: Int) {
        sectionModel(at: section)?.footerModel = nil
    }
    
    internal func updateItemSizeMode(sizeMode: SwiftyCollectionViewFlowLayoutSizeMode, at indexPath: IndexPath) {
        itemModel(at: indexPath)?.sizeMode = sizeMode
    }
}

extension ModeState {
    private func updateItemSize(preferredSize: CGSize, indexPath: IndexPath) {
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: indexPath.section) else {
            return
        }
        guard let itemModel = itemModel(at: indexPath) else {
            return
        }
        
        let scrollDirection = layout.scrollDirection
        
        switch sectionModel.sectionType {
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
            case .tagList:
                var frame = itemModel.frame
                frame.size.width = preferredSize.width // update width
                frame.size.height = preferredSize.height // update height
                itemModel.frame = frame
        }
    }
    
    private func updateHeaderSize(preferredSize: CGSize, section: Int) {
        guard let layout = layout else { return }
        guard let headerModel = headerModel(at: section) else {
            return
        }
        let scrollDirection = layout.scrollDirection
        switch scrollDirection {
            case .vertical:
                var frame = headerModel.frame
                frame.size.height = preferredSize.height // update height
                headerModel.frame = frame
            case .horizontal:
                var frame = headerModel.frame
                frame.size.width = preferredSize.width // update width
                headerModel.frame = frame
            default:
                break
        }
    }
    
    private func updateFooterSize(preferredSize: CGSize, section: Int) {
        guard let layout = layout else { return }
        guard let footerModel = footerModel(at: section) else {
            return
        }
        let scrollDirection = layout.scrollDirection
        switch scrollDirection {
            case .vertical:
                var frame = footerModel.frame
                frame.size.height = preferredSize.height // update height
                footerModel.frame = frame
            case .horizontal:
                var frame = footerModel.frame
                frame.size.width = preferredSize.width // update width
                footerModel.frame = frame
            default:
                break
        }
    }
    
    private func reloadSectionModels(sectionModelReloadIndexPairs: [(sectionModel: SectionModel, reloadIndex: Int)]) {
        for (sectionModel, reloadIndex) in sectionModelReloadIndexPairs {
            currentSectionModels.remove(at: reloadIndex)
            currentSectionModels.insert(sectionModel, at: reloadIndex)
        }
    }
    
    private func reloadItemModels(itemModelReloadIndexPathPairs: [(itemModel: ItemModel, reloadIndexPath: IndexPath)]) {
        for (itemModel, reloadIndexPath) in itemModelReloadIndexPathPairs {
            currentSectionModels[reloadIndexPath.section].deleteItemModel(atIndex: reloadIndexPath.item)
            currentSectionModels[reloadIndexPath.section].insert(itemModel, atIndex: reloadIndexPath.item)
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
            currentSectionModels[indexPathOfItemModelToDelete.section].deleteItemModel(atIndex: indexPathOfItemModelToDelete.item)
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
            currentSectionModels[insertIndexPath.section].insert(itemModel, atIndex: insertIndexPath.item)
        }
    }
}

extension ModeState {
    internal func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        guard let layout = layout else { return false }
        guard let sectionModel = sectionModel(at: preferredAttributes.indexPath.section) else {
            return false
        }
        
        let scrollDirection = layout.scrollDirection
        
        let isSameWidth = preferredAttributes.size.width.isEqual(to: originalAttributes.size.width)
        let isSameHeight = preferredAttributes.size.height.isEqual(to: originalAttributes.size.height)
        
        switch preferredAttributes.representedElementCategory {
            case .cell:
                switch sectionModel.sectionType {
                    case .waterFlow:
                        guard let itemModel = itemModel(at: preferredAttributes.indexPath) else {
                            return false
                        }
                        switch scrollDirection {
                            case .vertical:
                                switch itemModel.sizeMode.height {
                                    case .dynamic:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                            case .horizontal:
                                switch itemModel.sizeMode.width {
                                    case .dynamic:
                                        return !isSameWidth
                                    case .static:
                                        return false
                                }
                            default:
                                break
                        }
                    case .tagList:
                        guard let itemModel = itemModel(at: preferredAttributes.indexPath) else {
                            return false
                        }
                        switch itemModel.sizeMode.width {
                            case .dynamic:
                                switch itemModel.sizeMode.height {
                                    case .dynamic:
                                        return !isSameWidth || !isSameHeight
                                    case .static:
                                        return !isSameWidth
                                }
                            case .static:
                                switch itemModel.sizeMode.height {
                                    case .dynamic:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                        }
                }
            case .supplementaryView:
                switch preferredAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerModel = headerModel(at: preferredAttributes.indexPath.section) else {
                            return false
                        }
                        switch scrollDirection {
                            case .vertical:
                                switch headerModel.sizeMode.height {
                                    case .dynamic:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                            case .horizontal:
                                switch headerModel.sizeMode.width {
                                    case .dynamic:
                                        return !isSameWidth
                                    case .static:
                                        return false
                                }
                            default:
                                break
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerModel = footerModel(at: preferredAttributes.indexPath.section) else {
                            return false
                        }
                        switch scrollDirection {
                            case .vertical:
                                switch footerModel.sizeMode.height {
                                    case .dynamic:
                                        return !isSameHeight
                                    case .static:
                                        return false
                                }
                            case .horizontal:
                                switch footerModel.sizeMode.width {
                                    case .dynamic:
                                        return !isSameWidth
                                    case .static:
                                        return false
                                }
                            default:
                                break
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
            layoutDecorationModel(at: section)
        }
        var attrs: [UICollectionViewLayoutAttributes] = []
        for (section, sectionModel) in currentSectionModels.enumerated() {
            if let headerModel = sectionModel.headerModel {
//                if rect.contains(headerModel.frame) || rect.intersects(headerModel.frame) {
                    let attr = headerLayoutAttributes(at: section,
                                                      frame: headerModel.frame,
                                                      sectionModel: sectionModel,
                                                      sizeMode: headerModel.sizeMode)
                    attrs.append(attr)
//                }
            }
            for (index, itemModel) in sectionModel.itemModels.enumerated() {
//                if rect.contains(itemModel.frame) || rect.intersects(itemModel.frame) {
                    let indexPath = IndexPath(item: index, section: section)
                    let attr = itemLayoutAttributes(at: indexPath,
                                                    frame: itemModel.frame,
                                                    sectionModel: sectionModel,
                                                    sizeMode: itemModel.sizeMode)
                    attrs.append(attr)
//                }
            }
            if let footerModel = sectionModel.footerModel {
//                if rect.contains(footerModel.frame) || rect.intersects(footerModel.frame) {
                    let attr = footerLayoutAttributes(at: section,
                                                      frame: footerModel.frame,
                                                      sectionModel: sectionModel,
                                                      sizeMode: footerModel.sizeMode)
                    attrs.append(attr)
//                }
            }
            if let decorationModel = sectionModel.decorationModel {
//                if rect.contains(decorationModel.frame) || rect.intersects(decorationModel.frame) {
                    let attr = decorationLayoutAttributes(at: section, frame: decorationModel.frame)
                    attrs.append(attr)
//                }
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
