//
//  SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation

public enum SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode: Equatable {
    case hidden
    case visible(sizeMode: SwiftyCollectionViewFlowLayoutSizeMode/*, pinToVisibleBounds: Bool*/)
}
