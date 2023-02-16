//
//  InternalSizeMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/16.
//

import Foundation

internal struct InternalSizeMode: Equatable {
    internal let width: InternalLengthMode
    internal let height: InternalLengthMode
    
    internal init(width: InternalLengthMode, height: InternalLengthMode) {
        self.width = width
        self.height = height
    }
}
