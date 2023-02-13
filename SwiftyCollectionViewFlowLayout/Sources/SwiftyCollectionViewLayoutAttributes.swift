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
    
    internal var sectionModel: SectionModel?
    internal weak var layout: SwiftyCollectionViewFlowLayout?
    
    public internal(set) var sizeMode: SwiftyCollectionViewLayoutSizeMode = Default.sizeMode
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewLayoutAttributes
        copy.sizeMode = sizeMode
        copy.sectionModel = sectionModel
        copy.layout = layout
        return copy
    }
}
