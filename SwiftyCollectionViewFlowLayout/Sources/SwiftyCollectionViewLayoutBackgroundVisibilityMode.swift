//
//  SwiftyCollectionViewLayoutBackgroundVisibilityMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/13.
//

import Foundation


/// Represents the visibility mode for a background.
public enum SwiftyCollectionViewLayoutBackgroundVisibilityMode {
    
    /// This visibility mode will cause the background to not be visible in its respective section.
    case hidden
    
    /// This visibility mode will cause the background to be displayed behind the items and headers/footers in
    /// its respective section.
    case visible
}
