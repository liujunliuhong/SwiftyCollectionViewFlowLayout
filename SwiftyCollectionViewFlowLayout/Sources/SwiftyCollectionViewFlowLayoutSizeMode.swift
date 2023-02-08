//
//  SwiftyCollectionViewFlowLayoutSizeMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation

public struct SwiftyCollectionViewFlowLayoutSizeMode: Equatable {
    public let width: SwiftyCollectionViewFlowLayoutLengthMode
    public let height: SwiftyCollectionViewFlowLayoutLengthMode
    
    public init(width: SwiftyCollectionViewFlowLayoutLengthMode,
                height: SwiftyCollectionViewFlowLayoutLengthMode) {
        self.width = width
        self.height = height
    }
    
    public static let `default` = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: Default.size.width),
                                                                         height: .static(length: Default.size.height))
}
