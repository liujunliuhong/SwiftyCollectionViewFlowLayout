//
//  SwiftyCollectionViewSectionType.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/12.
//

import Foundation

/// Represents the section type.
public enum SwiftyCollectionViewSectionType: Equatable {
    
    /// water flow
    case waterFlow(numberOfColumns: Int)
    
    /// row
    case row(direction: SwiftyCollectionViewRowDirection = .left, alignment: SwiftyCollectionViewRowAlignment = .top)
}


/// Represents the row alignment.
public enum SwiftyCollectionViewRowAlignment: Equatable {
    
    /// if scrollDirection equal to horizontal, this mode represents left.
    case top
    
    /// center
    case center
    
    /// if scrollDirection equal to horizontal, this mode represents right.
    case bottom
}

/// Represents the row direction.
public enum SwiftyCollectionViewRowDirection: Equatable {
    
    /// if scrollDirection equal to horizontal, this mode represents top.
    case left
    
    /// if scrollDirection equal to horizontal, this mode represents bottom.
    case right
}
