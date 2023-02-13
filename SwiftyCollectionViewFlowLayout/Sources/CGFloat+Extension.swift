//
//  CGFloat+Extension.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation

extension CGFloat {
    
    /// Rounds `self` so that it's aligned on a pixel boundary for a screen with the provided scale.
    internal func alignedToPixel(forScreenWithScale scale: CGFloat) -> CGFloat {
        let result = (self * scale).rounded(.up) / scale
        return result
    }
    
    /// Tests `self` for approximate equality using the threshold value. For example, 1.48 equals 1.52 if the threshold is 0.05.
    /// `threshold` will be treated as a positive value by taking its absolute value.
    internal func isEqual(to rhs: CGFloat, threshold: CGFloat) -> Bool {
        abs(self - rhs) <= abs(threshold)
    }
}
