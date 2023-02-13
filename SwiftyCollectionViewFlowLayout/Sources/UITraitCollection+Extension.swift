//
//  UITraitCollection+Extension.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation
import UIKit

extension UITraitCollection {
    internal var nonZeroDisplayScale: CGFloat {
        displayScale > 0 ? displayScale : 1
    }
}
