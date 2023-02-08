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
    
    internal let layout: () -> SwiftyCollectionViewFlowLayout
    
    
    internal init(layout: @escaping () -> SwiftyCollectionViewFlowLayout) {
        self.layout = layout
    }
}

extension ModeState {
    internal func clear() {
        currentSectionModels.removeAll()
    }
    
    internal func setSections(_ sectionModels: [SectionModel]) {
        let sectionModels = sectionModels
        for sectionModel in sectionModels {
            updateInitialHeaderSize(sectionModel: sectionModel)
            updateInitialItemSize(sectionModel: sectionModel)
            updateInitialFooterSize(sectionModel: sectionModel)
        }
        currentSectionModels = sectionModels
    }
}

extension ModeState {
    private func updateInitialHeaderSize(sectionModel: SectionModel) {
        guard let headerModel = sectionModel.headerModel else { return }
        let scrollDirection = layout().scrollDirection
        switch scrollDirection {
            case .vertical:
                var width = layout().mCollectionView.bounds.width
                if sectionModel.sectionInsetContainHeader {
                    width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
                }
                
                var frame = headerModel.frame
                frame.size.width = width
                headerModel.frame = frame
            case .horizontal:
                var height = layout().mCollectionView.bounds.height
                if sectionModel.sectionInsetContainHeader {
                    height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
                }
                
                var frame = headerModel.frame
                frame.size.height = height
                headerModel.frame = frame
            default:
                break
        }
    }
    
    private func updateInitialFooterSize(sectionModel: SectionModel) {
        guard let footerModel = sectionModel.footerModel else { return }
        let scrollDirection = layout().scrollDirection
        switch scrollDirection {
            case .vertical:
                var width = layout().mCollectionView.bounds.width
                if sectionModel.sectionInsetContainFooter {
                    width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
                }
                
                var frame = footerModel.frame
                frame.size.width = width
                footerModel.frame = frame
            case .horizontal:
                var height = layout().mCollectionView.bounds.height
                if sectionModel.sectionInsetContainFooter {
                    height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
                }
                
                var frame = footerModel.frame
                frame.size.height = height
                footerModel.frame = frame
            default:
                break
        }
    }
    
    private func updateInitialItemSize(sectionModel: SectionModel) {
        switch sectionModel.sectionType {
            case .waterFlow(let numberOfColumns):
                let itemModels = sectionModel.itemModels
                let scrollDirection = layout().scrollDirection
                switch scrollDirection {
                    case .vertical:
                        let columnWidth = (layout().mCollectionView.frame.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
                        
                        for itemModel in itemModels {
                            var frame = itemModel.frame
                            frame.size.width = columnWidth
                            itemModel.frame = frame
                        }
                        
                    case .horizontal:
                        let columnHeight = (layout().mCollectionView.frame.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
                        for itemModel in itemModels {
                            var frame = itemModel.frame
                            frame.size.height = columnHeight
                            itemModel.frame = frame
                        }
                    default:
                        break
                }
                
                var bodyColumnLengths: [CGFloat] = []
                for _ in 0..<numberOfColumns {
                    bodyColumnLengths.append(.zero)
                }
                sectionModel.waterFlowBodyColumnLengths = bodyColumnLengths
                
            default:
                break
        }
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
    
    internal func previousSectionTotalLength(currentSection: Int) -> CGFloat {
        let scrollDirection = layout().scrollDirection
        var totalLength: CGFloat = .zero
        for (i, sectionModel) in currentSectionModels.enumerated() {
            if i < currentSection {
                totalLength += sectionModel.totalLength(scrollDirection: scrollDirection)
            }
        }
        return totalLength
    }
}

extension ModeState {
    private func updateItemSize(preferredSize: CGSize, indexPath: IndexPath) {
        guard let sectionModel = sectionModel(at: indexPath.section) else {
            return
        }
        guard let itemModel = itemModel(at: indexPath) else {
            return
        }
        switch sectionModel.sectionType {
            case .waterFlow:
                let scrollDirection = layout().scrollDirection
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
        guard let headerModel = headerModel(at: section) else {
            return
        }
        let scrollDirection = layout().scrollDirection
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
        guard let footerModel = footerModel(at: section) else {
            return
        }
        let scrollDirection = layout().scrollDirection
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
}

extension ModeState {
    internal func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        guard let sectionModel = sectionModel(at: preferredAttributes.indexPath.section) else {
            return false
        }
        
        let scrollDirection = layout().scrollDirection
        
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
        var shouldInvalidateLayout: Bool = false
        
        let scrollDirection = layout().scrollDirection
        
        let isSameWidth = layout().mCollectionView.bounds.width.isEqual(to: newBounds.size.width)
        let isSameHeight = layout().mCollectionView.bounds.height.isEqual(to: newBounds.size.height)
        
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
}

extension ModeState {
    
}
