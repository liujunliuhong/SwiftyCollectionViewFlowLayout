//
//  SwiftyCollectionViewFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

/// `SwiftyCollectionViewFlowLayout`, Inherit `UICollectionViewLayout`
open class SwiftyCollectionViewFlowLayout: UICollectionViewLayout {
    
    public static let decorationElementKind = "SwiftyCollectionViewFlowLayout.DecorationElementKind"
    
    internal var mDelegate: SwiftyCollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? SwiftyCollectionViewDelegateFlowLayout
    }
    
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
    
    internal lazy var modeState: ModeState = {
        let modeState = ModeState {
            return self
        }
        return modeState
    }()
    
    
    //    private var scale: CGFloat {
    //        collectionView?.traitCollection.nonZeroDisplayScale ?? 1
    //    }
    
//    internal var sectionModels: [Int: BaseSectionModel] = [:]
    
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCollectionViewFlowLayout {
    
    open override func prepare() {
        super.prepare()
//        guard let collectionView = collectionView else { return }
//        //
//        sectionModels.removeAll()
//        //
//        _prepare()
//        //
//        _layout()
//        //
//        mDelegate?.collectionView(collectionView, layout: self, contentSizeDidChange: collectionViewContentSize)
        print("prepare")
        
        
        modeState.clear()
        
        let numberOfSections = mCollectionView.numberOfSections
        var sectionModels: [SectionModel] = []
        for section in 0..<numberOfSections {
            let sectionModel = sectionModelForSection(at: section)
            sectionModels.append(sectionModel)
        }
        modeState.setSections(sectionModels)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = modeState.layoutAttributesForElements(in: rect)
        return attrs
        //        var elements: [UICollectionViewLayoutAttributes] = []
        //        for (_, v) in sectionModels.enumerated() {
        //            let section = v.value
        //            // header
        //            if let attr = section.headerLayoutAttributes {
        //                elements.append(attr)
        //            }
        //            // items
        //            elements.append(contentsOf: section.itemLayoutAttributes)
        //            // footer
        //            if let attr = section.footerLayoutAttributes {
        //                elements.append(attr)
        //            }
        //            // group decoration
        //            if let attr = section.groupDecorationAttributes {
        //                elements.append(attr)
        //            }
        //        }
        //        return elements
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return modeState.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    
    open override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if preferredAttributes.indexPath.isEmpty {
            return super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        }
        return modeState.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
    }
    
    open override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        
        modeState.updatePreferredLayoutAttributesSize(preferredAttributes: preferredAttributes)
        
        let invalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
        return invalidationContext
    }
    
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        //
        var totalLength: CGFloat = .zero
        for (_, v) in sectionModels.enumerated() {
            let section = v.value
            totalLength += section.totalLength(scrollDirection: scrollDirection)
        }
        //
        var size = super.collectionViewContentSize
        switch scrollDirection {
            case .vertical:
                size = CGSize(width: collectionView.bounds.width, height: totalLength)
            case .horizontal:
                size = CGSize(width: totalLength, height: collectionView.bounds.height)
            @unknown default:
                break
        }
        return size
    }
}

//extension SwiftyCollectionViewFlowLayout {
//    internal func getBeforeSectionTotalLength(currentSection: Int) -> CGFloat {
//        var totalLength: CGFloat = .zero
//        for (_, element) in sectionModels.enumerated() {
//            let section = element.key
//            let model = element.value
//            if section < currentSection {
//                totalLength += model.totalLength(scrollDirection: scrollDirection)
//            }
//        }
//        return totalLength
//    }
//}


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
