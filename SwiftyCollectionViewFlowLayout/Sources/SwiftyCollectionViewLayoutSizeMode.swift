//
//  SwiftyCollectionViewLayoutSizeMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation


/// Represents the horizontal and vertical sizing mode for an item/header/footer.
public struct SwiftyCollectionViewLayoutSizeMode: Equatable {
    
    /// The width mode for the item/header/footer.
    public let width: SwiftyCollectionViewLayoutLengthMode
    
    /// The height mode for the item/header/footer.
    public let height: SwiftyCollectionViewLayoutLengthMode
    
    public init(width: SwiftyCollectionViewLayoutLengthMode,
                height: SwiftyCollectionViewLayoutLengthMode) {
        self.width = width
        self.height = height
    }
    
    internal static let `default` = SwiftyCollectionViewLayoutSizeMode(width: .static(length: Default.size.width),
                                                                       height: .static(length: Default.size.height))
}
