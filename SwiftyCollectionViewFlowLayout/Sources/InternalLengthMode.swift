//
//  InternalLengthMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/16.
//

import Foundation

internal enum InternalLengthMode: Equatable {
    case absolute(length: CGFloat)
    case dynamic(increment: CGFloat)
    case ratio(_ ratio: CGFloat)
}
