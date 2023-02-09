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
//        guard let headerModel = sectionModel.headerModel else { return }
//        let scrollDirection = layout().scrollDirection
//        switch scrollDirection {
//            case .vertical:
//                var width = layout().mCollectionView.bounds.width
//                if sectionModel.sectionInsetContainHeader {
//                    width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
//                }
//                var frame = headerModel.frame
//                frame.size.width = width
//                headerModel.frame = frame
//
//                // reset sizeMode.width
////                headerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: width), height: headerModel.sizeMode.height)
//
//            case .horizontal:
//                var height = layout().mCollectionView.bounds.height
//                if sectionModel.sectionInsetContainHeader {
//                    height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
//                }
//
//                var frame = headerModel.frame
//                frame.size.height = height
//                headerModel.frame = frame
//
//                // reset sizeMode.height
//                headerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: headerModel.sizeMode.width, height: .static(length: height))
//            default:
//                break
//        }
    }
    
    private func updateInitialFooterSize(sectionModel: SectionModel) {
//        guard let footerModel = sectionModel.footerModel else { return }
//        let scrollDirection = layout().scrollDirection
//        switch scrollDirection {
//            case .vertical:
//                var width = layout().mCollectionView.bounds.width
//                if sectionModel.sectionInsetContainFooter {
//                    width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
//                }
//
//                var frame = footerModel.frame
//                frame.size.width = width
//                footerModel.frame = frame
//
//                // reset sizeMode.width
//                footerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: width), height: footerModel.sizeMode.height)
//
//            case .horizontal:
//                var height = layout().mCollectionView.bounds.height
//                if sectionModel.sectionInsetContainFooter {
//                    height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
//                }
//
//                var frame = footerModel.frame
//                frame.size.height = height
//                footerModel.frame = frame
//
//                // reset sizeMode.height
//                footerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: footerModel.sizeMode.width, height: .static(length: height))
//            default:
//                break
//        }
    }
    
    private func updateInitialItemSize(sectionModel: SectionModel) {
//        guard let layout = layout else { return }
//        switch sectionModel.sectionType {
//            case .waterFlow(let numberOfColumns):
//                let itemModels = sectionModel.itemModels
//                let scrollDirection = layout.scrollDirection
//                switch scrollDirection {
//                    case .vertical:
//                        let columnWidth = (layout.mCollectionView.frame.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
//
//                        for itemModel in itemModels {
//                            var frame = itemModel.frame
//                            frame.size.width = columnWidth
//                            itemModel.frame = frame
//
//                            // reset sizeMode.width
//                            itemModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: columnWidth), height: itemModel.sizeMode.height)
//                        }
//
//                    case .horizontal:
//                        let columnHeight = (layout.mCollectionView.frame.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
//                        for itemModel in itemModels {
//                            var frame = itemModel.frame
//                            frame.size.height = columnHeight
//                            itemModel.frame = frame
//
//                            // reset sizeMode.height
//                            itemModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: itemModel.sizeMode.width, height: .static(length: columnHeight))
//                        }
//                    default:
//                        break
//                }
//
//                var bodyColumnLengths: [CGFloat] = []
//                for _ in 0..<numberOfColumns {
//                    bodyColumnLengths.append(.zero)
//                }
//                sectionModel.waterFlowBodyColumnLengths = bodyColumnLengths
//
//            case .tagList:
//                break
//            default:
//                break
//        }
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
//                var frame = itemModel.frame
//                frame.size.width = preferredSize.width // update width
//                frame.size.height = preferredSize.height // update height
//                itemModel.frame = frame
                
                var frame = itemModel.frame
                switch scrollDirection {
                    case .vertical:
                        let containerWidth = layout.mCollectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right

                        if !preferredSize.width.isLessThanOrEqualTo(containerWidth) {
                            frame.size.width = containerWidth
                            itemModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: containerWidth), height: itemModel.sizeMode.height)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                layout.invalidateLayout()
                            }
//                            layout.invalidateLayout()
                        } else {
                            frame.size.width = preferredSize.width
                        }
                        frame.size.height = preferredSize.height
                    default:
                        break
                }
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
                        print("\(#function), \(preferredAttributes.indexPath), \(preferredAttributes.size.height)")
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
        print("shouldInvalidateLayout: \(shouldInvalidateLayout)")
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
                                if rect.contains(headerModel.frame) || rect.intersects(headerModel.frame) {
                let attr = headerLayoutAttributes(at: section, frame: headerModel.frame)
                attrs.append(attr)
                                }
            }
            for (index, itemModel) in sectionModel.itemModels.enumerated() {
//                                if rect.contains(itemModel.frame) || rect.intersects(itemModel.frame) {
                let indexPath = IndexPath(item: index, section: section)
                let attr = itemLayoutAttributes(at: indexPath, sectionModel: sectionModel, itemModel: itemModel)
                attrs.append(attr)
//                                }
            }
            if let footerModel = sectionModel.footerModel {
                                if rect.contains(footerModel.frame) || rect.intersects(footerModel.frame) {
                let attr = footerLayoutAttributes(at: section, frame: footerModel.frame)
                attrs.append(attr)
                                }
            }
            if let decorationModel = sectionModel.decorationModel {
                                if rect.contains(decorationModel.frame) || rect.intersects(decorationModel.frame) {
                let attr = decorationLayoutAttributes(at: section, frame: decorationModel.frame)
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
extension ModeState {
    
}
