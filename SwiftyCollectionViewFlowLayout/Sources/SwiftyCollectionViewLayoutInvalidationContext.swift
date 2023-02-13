//
//  SwiftyCollectionViewLayoutInvalidationContext.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation
import UIKit

/// Used to indicate that collection view properties and/or delegate layout metrics changed.
public final class SwiftyCollectionViewLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {
    
    /// Indicates whether to recompute the positions and sizes of elements based on the current
    /// collection view and delegate layout metrics.
    public var invalidateLayoutMetrics = true
}
