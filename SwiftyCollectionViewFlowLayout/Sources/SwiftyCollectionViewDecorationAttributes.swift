//
//  SwiftyCollectionViewDecorationAttributes.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation
import UIKit

/// Decoration view extra attributes
open class SwiftyCollectionViewDecorationExtraAttributes {
    public init() {}
}


/// Decoration attributes
public final class SwiftyCollectionViewDecorationAttributes: UICollectionViewLayoutAttributes {
    
    public internal(set) var extraAttributes: SwiftyCollectionViewDecorationExtraAttributes?
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewDecorationAttributes
        copy.extraAttributes = extraAttributes
        return copy
    }
}
