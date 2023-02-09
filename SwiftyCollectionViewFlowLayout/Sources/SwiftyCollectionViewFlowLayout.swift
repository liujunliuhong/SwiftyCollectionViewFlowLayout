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
}

/// `SwiftyCollectionViewFlowLayout`, Inherit `UICollectionViewLayout`
public final class SwiftyCollectionViewFlowLayout: UICollectionViewLayout {
    deinit {
        print("☁️☁️☁️☁️☁️☁️☁️☁️☁️")
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
        print(#function)
        
        if prepareActions.isEmpty {
            return
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
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(#function)
        let attrs = modeState.layoutAttributesForElements(in: rect)
        return attrs
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        let shouldInvalidateLayout = modeState.shouldInvalidateLayout(forBoundsChange: newBounds)
//        print("\(#function) \(shouldInvalidateLayout)")
//        return shouldInvalidateLayout
        return true
    }
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if preferredAttributes.indexPath.isEmpty {
            return super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        }
        let shouldInvalidateLayout = modeState.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
        print("\(#function), \(shouldInvalidateLayout)")
        
        return shouldInvalidateLayout
    }
    
    public override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        
        let invalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
        print("\(#function), \(preferredAttributes.indexPath), \(preferredAttributes.size.height)")
        
        modeState.updatePreferredLayoutAttributesSize(preferredAttributes: preferredAttributes)
        
        print("\(#function), \(invalidationContext.invalidateEverything), \(invalidationContext.invalidateDataSourceCounts)")
        
//        invalidationContext.invalidateItems(at: [preferredAttributes.indexPath])
        
        return invalidationContext
    }
    
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        print("\(#function), \(context.invalidateEverything), \(context.invalidateDataSourceCounts)")
        
        if context.invalidateEverything {
            prepareActions.formUnion([.recreateSectionModels])
        }
    }
    
    
    public override var collectionViewContentSize: CGSize {
        print(#function)
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
        
        return SectionModel(sectionType: sectionTypeForSection(at: section),
                            headerModel: headerModelForHeader(at: section),
                            footerModel: footerModelForFooter(at: section),
                            itemModels: itemModels,
                            decorationModel: decorationModel(at: section),
                            sectionInset: sectionInsetForSection(at: section),
                            lineSpacing: lineSpacingForSection(at: section),
                            interitemSpacing: interitemSpacingForSection(at: section),
                            sectionInsetContainHeader: sectionInsetContainHeaderForSection(at: section),
                            sectionInsetContainFooter: sectionInsetContainFooterForSection(at: section))
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
    
    private func sectionTypeForSection(at section: Int) -> SwiftyCollectionViewSectionType {
        guard let mDelegate = mDelegate else { return Default.sectionType }
        return mDelegate.collectionView(mCollectionView, layout: self, sectionType: section)
    }
    
    private func sectionInsetForSection(at section: Int) -> UIEdgeInsets {
        guard let mDelegate = mDelegate else { return Default.sectionInset }
        return mDelegate.collectionView(mCollectionView, layout: self, insetForSectionAt: section)
    }
    
    private func lineSpacingForSection(at section: Int) -> CGFloat {
        guard let mDelegate = mDelegate else { return Default.lineSpacing }
        return mDelegate.collectionView(mCollectionView, layout: self, lineSpacingForSectionAt: section)
    }
    
    private func interitemSpacingForSection(at section: Int) -> CGFloat {
        guard let mDelegate = mDelegate else { return Default.interitemSpacing }
        return mDelegate.collectionView(mCollectionView, layout: self, interitemSpacingForSectionAt: section)
    }
    
    private func sectionInsetContainHeaderForSection(at section: Int) -> Bool {
        guard let mDelegate = mDelegate else { return Default.sectionInsetContainHeader }
        return mDelegate.collectionView(mCollectionView, layout: self, sectionInsetContainHeader: section)
    }
    
    private func sectionInsetContainFooterForSection(at section: Int) -> Bool {
        guard let mDelegate = mDelegate else { return Default.sectionInsetContainFooter }
        return mDelegate.collectionView(mCollectionView, layout: self, sectionInsetContainFooter: section)
    }
}
