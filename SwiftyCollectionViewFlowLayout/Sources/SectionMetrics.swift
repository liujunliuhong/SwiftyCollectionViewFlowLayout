//
//  SectionMetrics.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/11.
//

import Foundation
import UIKit

internal final class SectionMetrics {
    
    internal let sectionType: SwiftyCollectionViewSectionType
    internal let sectionInset: UIEdgeInsets
    internal let lineSpacing: CGFloat
    internal let interitemSpacing: CGFloat
    internal let sectionInsetContainHeader: Bool
    internal let sectionInsetContainFooter: Bool
    internal let headerOffset: UIOffset
    internal let footerOffset: UIOffset
    internal let headerDirection: SwiftyCollectionViewLayoutSupplementaryDirection
    internal let footerDirection: SwiftyCollectionViewLayoutSupplementaryDirection
    
    internal let scale: CGFloat
    
    internal init(section: Int,
                  collectionView: UICollectionView,
                  layout: SwiftyCollectionViewFlowLayout,
                  delegate: SwiftyCollectionViewDelegateFlowLayout) {
        
        sectionType = delegate.collectionView(collectionView, layout: layout, sectionType: section)
        sectionInset = delegate.collectionView(collectionView, layout: layout, insetForSectionAt: section)
        lineSpacing = delegate.collectionView(collectionView, layout: layout, lineSpacingForSectionAt: section)
        interitemSpacing = delegate.collectionView(collectionView, layout: layout, interitemSpacingForSectionAt: section)
        sectionInsetContainHeader = delegate.collectionView(collectionView, layout: layout, sectionInsetContainHeader: section)
        sectionInsetContainFooter = delegate.collectionView(collectionView, layout: layout, sectionInsetContainFooter: section)
        headerOffset = delegate.collectionView(collectionView, layout: layout, headerOffset: section)
        footerOffset = delegate.collectionView(collectionView, layout: layout, footerOffset: section)
        headerDirection = delegate.collectionView(collectionView, layout: layout, headerDirection: section)
        footerDirection = delegate.collectionView(collectionView, layout: layout, footerDirection: section)
        
        scale = collectionView.traitCollection.nonZeroDisplayScale
    }
    
    
    
    private init(sectionType: SwiftyCollectionViewSectionType,
                 sectionInset: UIEdgeInsets,
                 lineSpacing: CGFloat,
                 interitemSpacing: CGFloat,
                 sectionInsetContainHeader: Bool,
                 sectionInsetContainFooter: Bool,
                 headerOffset: UIOffset,
                 footerOffset: UIOffset,
                 headerDirection: SwiftyCollectionViewLayoutSupplementaryDirection,
                 footerDirection: SwiftyCollectionViewLayoutSupplementaryDirection,
                 scale: CGFloat) {
        self.sectionType = sectionType
        self.sectionInset = sectionInset
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
        self.sectionInsetContainHeader = sectionInsetContainHeader
        self.sectionInsetContainFooter = sectionInsetContainFooter
        self.headerOffset = headerOffset
        self.footerOffset = footerOffset
        self.headerDirection = headerDirection
        self.footerDirection = footerDirection
        self.scale = scale
    }
    
    internal static let `default` = SectionMetrics(sectionType: Default.sectionType,
                                                   sectionInset: Default.sectionInset,
                                                   lineSpacing: Default.lineSpacing,
                                                   interitemSpacing: Default.interitemSpacing,
                                                   sectionInsetContainHeader: Default.sectionInsetContainHeader,
                                                   sectionInsetContainFooter: Default.sectionInsetContainFooter,
                                                   headerOffset: Default.headerOffet,
                                                   footerOffset: Default.footerOffet,
                                                   headerDirection: Default.headerDirection,
                                                   footerDirection: Default.footerDirection,
                                                   scale: Default.scale)
    
}
