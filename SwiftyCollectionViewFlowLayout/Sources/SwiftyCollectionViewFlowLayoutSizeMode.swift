//
//  SwiftyCollectionViewFlowLayoutSizeMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation

/// Represents the horizontal and vertical sizing mode for an item/header/footer.
public struct SwiftyCollectionViewFlowLayoutSizeMode: Equatable {
    
    /// The width mode for the item/header/footer.
    public let width: SwiftyCollectionViewFlowLayoutLengthMode
    
    /// The height mode for the item/header/footer.
    public let height: SwiftyCollectionViewFlowLayoutLengthMode
    
    public init(width: SwiftyCollectionViewFlowLayoutLengthMode,
                height: SwiftyCollectionViewFlowLayoutLengthMode) {
        self.width = width
        self.height = height
    }
    
    internal static let `default` = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: Default.size.width),
                                                                         height: .static(length: Default.size.height))
}
