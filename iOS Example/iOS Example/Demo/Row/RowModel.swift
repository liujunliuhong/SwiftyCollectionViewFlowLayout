//
//  RowModel.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation
import SwiftyCollectionViewFlowLayout

public class RowSectionModel {
    public let items: [RowItemModel]
    public init(items: [RowItemModel]) {
        self.items = items
    }
}

public class RowItemModel {
    public let width: SwiftyCollectionViewLayoutLengthMode
    public let height: SwiftyCollectionViewLayoutLengthMode
    
    public init(width: SwiftyCollectionViewLayoutLengthMode, height: SwiftyCollectionViewLayoutLengthMode) {
        self.width = width
        self.height = height
    }
}
