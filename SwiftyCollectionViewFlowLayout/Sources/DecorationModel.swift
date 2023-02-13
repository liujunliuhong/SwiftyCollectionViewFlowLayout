//
//  DecorationModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/8.
//

import Foundation
import UIKit

internal final class DecorationModel {
    internal let extraAttributes: SwiftyCollectionViewDecorationExtraAttributes?
    internal let extraInset: UIEdgeInsets
    
    internal var frame: CGRect = .zero
    
    internal init(extraAttributes: SwiftyCollectionViewDecorationExtraAttributes?, extraInset: UIEdgeInsets) {
        self.extraAttributes = extraAttributes
        self.extraInset = extraInset
    }
}
