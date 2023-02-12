//
//  SwiftyCollectionViewFlowLayoutDecorationVisibilityMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation

/// Represents the visibility mode for a decoration.
public enum SwiftyCollectionViewFlowLayoutDecorationVisibilityMode {
    
    /// This visibility mode will cause the decoration to not be visible in its respective section.
    case hidden
    
    /// This visibility mode will cause the decoration to be displayed behind the items and headers in
    /// its respective section.
    case visible(extraAttributes: SwiftyCollectionViewLayoutDecorationExtraAttributes?)
}
