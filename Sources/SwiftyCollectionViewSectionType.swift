//
//  SwiftyCollectionViewSectionType.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/12.
//

import Foundation

public enum SwiftyCollectionViewAlignment: Equatable {
    case top
    case center
    case bottom
}

public enum SwiftyCollectionViewDirection: Equatable {
    case left
    case right
}

public enum SwiftyCollectionViewSectionType: Equatable {
    case normal
    case waterFlow(numberOfColumns: Int)
    case tagList(alignment: SwiftyCollectionViewAlignment)
}
