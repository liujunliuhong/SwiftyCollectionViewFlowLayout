//
//  SwiftyCollectionViewLayoutDecorationAttributes.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/5.
//

import UIKit

/// Decoration view extra attributes
open class SwiftyCollectionViewLayoutDecorationExtraAttributes {
    public init() {}
}


/// Decoration attributes
public final class SwiftyCollectionViewLayoutDecorationAttributes: UICollectionViewLayoutAttributes {
    
    public internal(set) var extraAttributes: SwiftyCollectionViewLayoutDecorationExtraAttributes?
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewLayoutDecorationAttributes
        copy.extraAttributes = extraAttributes
        return copy
    }
}
