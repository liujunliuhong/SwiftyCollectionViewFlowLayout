//
//  SwiftyCollectionViewSectionType.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/12.
//

import Foundation


public enum SwiftyCollectionViewSectionType: Equatable {
    case waterFlow(numberOfColumns: Int)
    case tagList(direction: SwiftyCollectionViewTagDirection, alignment: SwiftyCollectionViewTagAlignment)
}


public enum SwiftyCollectionViewTagAlignment: Equatable {
    case top      /// if scrollDirection == .horizontal, equal left
    case center   /// center
    case bottom   /// if scrollDirection == .horizontal, equal right
}

public enum SwiftyCollectionViewTagDirection: Equatable {
    case left    /// if scrollDirection == .horizontal, equal top
    case right   /// if scrollDirection == .horizontal, equal bottom
}
