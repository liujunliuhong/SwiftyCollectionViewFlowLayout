//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

private struct PrepareActions: OptionSet {
    let rawValue: UInt
    static let recreateSectionModels = PrepareActions(rawValue: 1 << 0)
    static let updateLayoutMetrics = PrepareActions(rawValue: 1 << 1)
}


/// `SwiftyCollectionViewFlowLayout`, Inherit `UICollectionViewLayout`
public final class SwiftyCollectionViewFlowLayout: UICollectionViewLayout {
    deinit {
#if DEBUG
        print("\(self.classForCoder) deinit")
#endif
    }
    
    public static let DecorationElementKind = "SwiftyCollectionViewFlowLayout.DecorationElementKind"
    
    internal var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
    private var cacheContentSize: CGSize?
    
    internal var mCollectionView: UICollectionView {
        guard let mCollectionView = collectionView else {
            preconditionFailure("`collectionView` should not be `nil`")
        }
        return mCollectionView
    }
    
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            invalidateLayout()
        }
    }
    
    private var prepareActions: PrepareActions = []
    
    internal lazy var modeState: ModeState = {
        let modeState = ModeState(layout: self)
        return modeState
    }()
    
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCollectionViewFlowLayout {
    public override func prepare() {
        super.prepare()
        
        if prepareActions.isEmpty {
            return
        }
        
        if prepareActions.contains(.updateLayoutMetrics) {
            for section in 0..<modeState.numberOfSections() {
                
                let metrics = metricsForSection(at: section)
                modeState.updateMetrics(metrics, at: section)
                
                if let headerModel = headerModelForHeader(at: section) {
                    modeState.setHeader(headerModel: headerModel, at: section)
                } else {
                    modeState.removeFooter(at: section)
                }
                
                if let footerModel = footerModelForFooter(at: section) {
                    modeState.setFooter(footerModel: footerModel, at: section)
                } else {
                    modeState.removeFooter(at: section)
                }
                
                if let decorationModel = decorationModel(at: section) {
                    modeState.setDecoration(decorationModel: decorationModel, at: section)
                } else {
                    modeState.removeDecoration(at: section)
                }
                
                for i in 0..<modeState.numberOfItems(at: section) {
                    let indexPath = IndexPath(item: i, section: section)
                    modeState.updateItemSizeMode(sizeMode: sizeModeForItem(at: indexPath), at: indexPath)
                }
            }
        }
        
        if prepareActions.contains(.recreateSectionModels) {
            modeState.clear()
            let numberOfSections = mCollectionView.numberOfSections
            var sectionModels: [SectionModel] = []
            for section in 0..<numberOfSections {
                let sectionModel = sectionModelForSection(at: section)
                sectionModels.append(sectionModel)
            }
            modeState.setSections(sectionModels)
        }
        
        prepareActions = []
    }
    
    public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        var updates = [CollectionViewUpdate<SectionModel, ItemModel>]()
        
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction
            let indexPathBeforeUpdate = updateItem.indexPathBeforeUpdate
            let indexPathAfterUpdate = updateItem.indexPathAfterUpdate
            
            if updateAction == .reload {
                guard let indexPath = indexPathBeforeUpdate else { continue }
                if indexPath.item == NSNotFound {
                    let sectionModel = sectionModelForSection(at: indexPath.section)
                    updates.append(.sectionReload(sectionIndex: indexPath.section, newSection: sectionModel))
                } else {
                    let itemModel = itemModelForItem(at: indexPath)
                    updates.append(.itemReload(itemIndexPath: indexPath, newItem: itemModel))
                }
            }
            
            if updateAction == .delete {
                guard let indexPath = indexPathBeforeUpdate else { continue }
                if indexPath.item == NSNotFound {
                    updates.append(.sectionDelete(sectionIndex: indexPath.section))
                } else {
                    updates.append(.itemDelete(itemIndexPath: indexPath))
                }
            }
            
            if updateAction == .insert {
                guard let indexPath = indexPathAfterUpdate else { continue }
                if indexPath.item == NSNotFound {
                    let sectionModel = sectionModelForSection(at: indexPath.section)
                    updates.append(.sectionInsert(sectionIndex: indexPath.section, newSection: sectionModel))
                } else {
                    let itemModel = itemModelForItem(at: indexPath)
                    updates.append(.itemInsert(itemIndexPath: indexPath, newItem: itemModel))
                }
            }
            
            if updateAction == .move {
                guard let initialIndexPath = indexPathBeforeUpdate, let finalIndexPath = indexPathAfterUpdate else { continue }
                if initialIndexPath.item == NSNotFound && finalIndexPath.item == NSNotFound {
                    updates.append(.sectionMove(initialSectionIndex: initialIndexPath.section, finalSectionIndex: finalIndexPath.section))
                } else {
                    updates.append(.itemMove(initialItemIndexPath: initialIndexPath, finalItemIndexPath: finalIndexPath))
                }
            }
        }
        modeState.applyUpdates(updates)
    }
    
    public override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        modeState.clearInProgressBatchUpdateState()
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let sectionModel = modeState.sectionModel(at: indexPath.section) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        guard let itemModel = modeState.itemModel(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        let attr = modeState.itemLayoutAttributes(at: indexPath, frame: itemModel.frame, sectionModel: sectionModel, sizeMode: itemModel.sizeMode)
        return attr
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let sectionModel = modeState.sectionModel(at: indexPath.section) else {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        }
        if elementKind == UICollectionView.elementKindSectionHeader {
            guard let headerModel = modeState.headerModel(at: indexPath.section) else {
                return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
            }
            return modeState.headerLayoutAttributes(at: indexPath.section, frame: headerModel.frame, sectionModel: sectionModel, sizeMode: headerModel.sizeMode)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            guard let footerModel = modeState.footerModel(at: indexPath.section) else {
                return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
            }
            return modeState.footerLayoutAttributes(at: indexPath.section, frame: footerModel.frame, sectionModel: sectionModel, sizeMode: footerModel.sizeMode)
        }
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SwiftyCollectionViewFlowLayout.DecorationElementKind {
            guard let decorationModel = decorationModel(at: indexPath.section) else {
                return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
            }
            return modeState.decorationLayoutAttributes(at: indexPath.section, frame: decorationModel.frame)
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = modeState.layoutAttributesForElements(in: rect)
        return attrs
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let shouldInvalidateLayout = modeState.shouldInvalidateLayout(forBoundsChange: newBounds)
        return shouldInvalidateLayout
    }
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if preferredAttributes.indexPath.isEmpty {
            return super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        }
        let shouldInvalidateLayout = modeState.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        return shouldInvalidateLayout
    }
    
    public override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let invalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        modeState.updatePreferredLayoutAttributesSize(preferredAttributes: preferredAttributes)
        return invalidationContext
    }
    
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything {
            prepareActions.formUnion([.recreateSectionModels])
        }
        
        let shouldInvalidateLayoutMetrics = !context.invalidateEverything && !context.invalidateDataSourceCounts
        if shouldInvalidateLayoutMetrics {
            prepareActions.formUnion(.updateLayoutMetrics)
        }
        
        print("invalidateEverything: \(context.invalidateEverything), invalidateDataSourceCounts: \(context.invalidateDataSourceCounts)")
        
        super.invalidateLayout(with: context)
    }
    
    public override var collectionViewContentSize: CGSize {
        let size = modeState.collectionViewContentSize()
        
        if cacheContentSize == nil {
            mDelegate?.collectionView(mCollectionView, layout: self, contentSizeDidChange: size)
        } else {
            if !cacheContentSize!.equalTo(size) {
                mDelegate?.collectionView(mCollectionView, layout: self, contentSizeDidChange: size)
            }
        }
        cacheContentSize = size
        
        return size
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func sectionModelForSection(at section: Int) -> SectionModel {
        var itemModels: [ItemModel] = []
        let numberOfItems = mCollectionView.numberOfItems(inSection: section)
        for index in 0..<numberOfItems {
            let itemModel = itemModelForItem(at: IndexPath(item: index, section: section))
            itemModels.append(itemModel)
        }
        
        return SectionModel(headerModel: headerModelForHeader(at: section),
                            footerModel: footerModelForFooter(at: section),
                            itemModels: itemModels,
                            decorationModel: decorationModel(at: section),
                            metrics: metricsForSection(at: section))
    }
    
    private func itemModelForItem(at indexPath: IndexPath) -> ItemModel {
        let itemSizeMode = sizeModeForItem(at: indexPath)
        return ItemModel(sizeMode: itemSizeMode)
    }
    
    private func headerModelForHeader(at section: Int) -> HeaderModel? {
        let headerVisibilityMode = visibilityModeForHeader(at: section)
        switch headerVisibilityMode {
            case .hidden:
                return nil
            case .visible(let sizeMode):
                return HeaderModel(sizeMode: sizeMode)
        }
    }
    
    private func footerModelForFooter(at section: Int) -> FooterModel? {
        let footerVisibilityMode = visibilityModeForFooter(at: section)
        switch footerVisibilityMode {
            case .hidden:
                return nil
            case .visible(let sizeMode):
                return FooterModel(sizeMode: sizeMode)
        }
    }
    
    private func decorationModel(at section: Int) -> DecorationModel? {
        let decorationVisibilityMode = visibilityModeForDecoration(at: section)
        switch decorationVisibilityMode {
            case .hidden:
                return nil
            case .visible(let extraAttributes):
                return DecorationModel(extraAttributes: extraAttributes, extraInset: decorationExtraInset(at: section))
        }
    }
    
    private func sizeModeForItem(at indexPath: IndexPath) -> SwiftyCollectionViewFlowLayoutSizeMode {
        guard let mDelegate = mDelegate else { return Default.sizeMode }
        return mDelegate.collectionView(mCollectionView, layout: self, itemSizeModeAt: indexPath)
    }
    
    private func visibilityModeForHeader(at section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        guard let mDelegate = mDelegate else { return Default.headerVisibilityMode }
        return mDelegate.collectionView(mCollectionView, layout: self, visibilityModeForHeaderInSection: section)
    }
    
    private func visibilityModeForFooter(at section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        guard let mDelegate = mDelegate else { return Default.footerVisibilityMode }
        return mDelegate.collectionView(mCollectionView, layout: self, visibilityModeForFooterInSection: section)
    }
    
    private func visibilityModeForDecoration(at section: Int) -> SwiftyCollectionViewFlowLayoutDecorationVisibilityMode {
        guard let mDelegate = mDelegate else { return Default.decorationVisibilityMode }
        return mDelegate.collectionView(mCollectionView, layout: self, visibilityModeForDecorationInSection: section)
    }
    
    private func decorationExtraInset(at section: Int) -> UIEdgeInsets {
        guard let mDelegate = mDelegate else { return Default.decorationExtraInset }
        return mDelegate.collectionView(mCollectionView, layout: self, decorationExtraInset: section)
    }
    
    private func metricsForSection(at section: Int) -> SectionMetrics {
        guard let mDelegate = mDelegate else { return Default.metrics }
        return SectionMetrics(section: section, collectionView: mCollectionView, layout: self, delegate: mDelegate)
    }
}
