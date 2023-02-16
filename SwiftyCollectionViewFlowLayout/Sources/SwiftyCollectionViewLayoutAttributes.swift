//
//  SwiftyCollectionViewLayoutAttributes.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import UIKit

/// Used by `UICollectionViewCell` and `UICollectionReusableView` subclasses to determine which
/// vertical and horizontal fitting priority to pass into
/// `systemLayoutSizeFitting(_:withHorizontalFittingPriority:verticalFittingPriority)` via
/// `preferredLayoutAttributesFitting(_:)`.
public final class SwiftyCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public internal(set) var scrollDirection: UICollectionView.ScrollDirection = .vertical
    public internal(set) var maxSize: CGSize = Default.size
    
    internal var sizeMode: InternalSizeMode = .init(width: .absolute(length: Default.size.width), height: .absolute(length: Default.size.height))
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewLayoutAttributes
        copy.sizeMode = sizeMode
        copy.scrollDirection = scrollDirection
        copy.maxSize = maxSize
        return copy
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        let other = object as? SwiftyCollectionViewLayoutAttributes
        return super.isEqual(object) && other?.sizeMode == sizeMode && other?.scrollDirection == scrollDirection && other?.maxSize == maxSize
    }
}
