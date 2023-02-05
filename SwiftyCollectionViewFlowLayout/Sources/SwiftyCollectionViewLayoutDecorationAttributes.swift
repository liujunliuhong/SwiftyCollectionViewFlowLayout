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

open class SwiftyCollectionViewLayoutDecorationAttributes: UICollectionViewLayoutAttributes {
    public var extraAttributes: SwiftyCollectionViewLayoutDecorationExtraAttributes?
}
