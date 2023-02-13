//
//  SwiftyCollectionViewLayoutLengthMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation


/// Represents the width/height mode.
public enum SwiftyCollectionViewLayoutLengthMode: Equatable {
    
    /// Represents width/height equal to `length`.
    case `static`(length: CGFloat)
    
    /// Represents get its width/height from the Auto Layout engine.
    case dynamic(increment: CGFloat = .zero)
    
    /// If scrollDirection equal to `vertical`, represents `width` equal to `collectionView.width - sectionInset.left - sectionInset.right`, `height` equal to `collectionView.height`.
    /// If scrollDirection equal to `horizontal`, represents `width` equal to `collectionView.width`, `height` equal to `collectionView.height - sectionInset.top - sectionInset.bottom`.
    case full
    
    /// Fractional full items will take up `1/divisor` of the available width/height for a given row of
    /// items.
    ///
    /// Example: scrollDirection equal to `vertical`, `divisor` equal to `3`.
    /// width = `(collectionView.width - sectionInset.left - sectionInset.right - interitemSpacing * (3 - 1)) / divisor`.
    /// height = `collectionView.height / divisor`.
    ///
    /// - Warning: `divisor` must be greater than `0`. Specifying `0` as the `divisor` is a programmer
    /// error and **will result in a runtime crash**.
    case fractionalFull(divisor: UInt)
}
