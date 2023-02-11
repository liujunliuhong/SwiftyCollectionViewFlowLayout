//
//  SwiftyCollectionViewFlowLayoutLengthMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation

/// Length Mode
public enum SwiftyCollectionViewFlowLayoutLengthMode: Equatable {
    case `static`(length: CGFloat)
    case dynamic(increment: CGFloat = .zero)
    case full
    case fractionalFull(divisor: UInt)
}
