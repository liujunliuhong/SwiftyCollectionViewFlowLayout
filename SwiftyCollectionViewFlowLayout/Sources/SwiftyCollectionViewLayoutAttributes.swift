//
//  SwiftyCollectionViewLayoutAttributes.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import UIKit

public final class SwiftyCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    public private(set) var sizeMode: SwiftyCollectionViewFlowLayoutSizeMode = Default.sizeMode
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewLayoutAttributes
        copy.sizeMode = sizeMode
        return copy
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object) &&
        sizeMode == (object as? SwiftyCollectionViewLayoutAttributes)?.sizeMode
    }
}
