//
//  SwiftyCollectionViewSectionType.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/12.
//

import Foundation

public enum SwiftyCollectionViewAlignment: Equatable {
    case top      // if scrollDirection == .horizontal, equal left
    case center
    case bottom   // if scrollDirection == .horizontal, equal right
}

public enum SwiftyCollectionViewDirection: Equatable {
    case left    // if scrollDirection == .horizontal, equal top
    case right   // if scrollDirection == .horizontal, equal bottom
}

public enum SwiftyCollectionViewSectionType: Equatable {
    case normal
    case waterFlow(numberOfColumns: Int)
    case tagList(direction: SwiftyCollectionViewDirection, alignment: SwiftyCollectionViewAlignment)
}
